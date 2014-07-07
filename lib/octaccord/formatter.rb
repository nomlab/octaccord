module Octaccord
  class FormatterNameError < StandardError; end

  module Formatter
    def self.build(formatter: :text)
      case formatter.to_sym
      when :text
        Text.new
      when :pbl
        Pbl.new
      when :table
        Table.new
      when :list
        List.new
      else
        raise FormatterNameError.new("Unknown format: #{formatter}")
      end
    end

    class Base
      def initialize
        @issues = []
      end

      def <<(issue)
        @issues << Formatter::Issue.new(issue)
      end

      def to_s
        format_frame_header +
          format_header +
          format_body +
          format_footer +
          format_frame_footer
      end

      private

      def format_body
        @issues.map{|issue| format_item(issue)}.compact.join("\n") + "\n"
      end

      def format_frame_header
        "<!-- begin:octaccord #{self.class.name} -->\n"
      end

      def format_frame_footer
        "\n<!-- end:octaccord #{self.class.name} -->\n"
      end

      def format_header ;""; end
      def format_footer ;""; end
    end

    class Text < Base
      private

      def format_frame_header ; ""; end
      def format_frame_footer ; ""; end

      def format_item(issue)
        issue.summary
      end
    end # class Text

    class Pbl < Base
      private

      def format_header
          "| No.   | Title | Story | Demo  | Cost  |\n" +
          "| :---- | :---- | :---- | :---- | ----: |\n"
      end

      def format_item(issue)
        return nil unless issue.labels =~ /PBL/
        cols = []
        cols << "#{issue.plain_link}"
        cols << issue.title
        cols << issue.story
        cols << issue.demo
        cols << issue.cost
        cols = "| " + cols.join(" | ") + " |"
      end
    end # class Pbl

    class List < Base
      private

      def format_item(issue)
        headline = "##### #{issue.link} #{issue.status} #{issue.title}\n#{issue.comments}"
      end
    end # class List

    class Table < Base
      private

      def format_header
          "| No.   | Status   | Title |\n" +
          "| :---- | :------- | :---- |\n"
      end

      def format_item(issue)
        headline = "|#{issue.link} |#{issue.status} |#{issue.title}|"
      end
    end # class Table

    class Issue
      def initialize(issue)
        @issue = issue
      end

      def status
        return ":parking:" if labels =~ /PBL/
        return ":white_check_mark:" if @issue.state == "closed"
        return ":arrow_upper_left:" if @issue.pull_request
        return avatar if @issue.assignee
        days = ((Time.now - @issue.updated_at) / (24*3600)).to_i
        return ":ghost:" if days > 60
        return ":grey_question:"
      end

      def avatar
        if @issue.assignee
          return "![#{@issue.assignee.login}](#{@issue.assignee.avatar_url}s=20)"
        else
          return ":grey_question:"
          octcat = "https://assets-cdn.github.com/images/gravatars/gravatar-user-420.png"
          gravatar = "https://www.gravatar.com/avatar/00000000000000000000000000000000"
          return "![not assigned](#{gravatar}?d=#{URI.encode_www_form_component(octcat)}&r=x&s=10)"
        end
      end

      def pr
        if @issue.pull_request then ":arrow_upper_left:" else nil end
      end

      def summary
        "##{@issue.number} #{@issue.title}" + (labels != "" ? " (#{labels})" : "")
      end

      def link
        type = if @issue.pull_request then "pull" else "issues" end
        "[##{@issue.number}](../#{type}/#{@issue.number} \"#{@issue.title}\")"
      end

      def plain_link
        type = if @issue.pull_request then "pull" else "issues" end
        "[##{@issue.number}](../#{type}/#{@issue.number})"
      end

      def comments
        # https://github.com/octokit/octokit.rb#uri-templates
        comments = []

        STDERR.puts "* issue comments: #{@issue.rels[:comments].href}"

        @issue.rels[:comments].get.data.each do |c|
          comments << adjust_indent(c.body)
        end
        return comments.join
      end
      def title
        if @issue.state == "closed" then "~~#{@issue.title}~~" else @issue.title end
      end

      def labels
        @issue.labels.map{|label| label.name}.join(',')
      end

      def milestone
        if @issue.milestone then "_#{@issue.milestone.title}_" else nil end
      end

      def story
        extract_section(@issue.body, "Story")
      end

      def demo
        extract_section(@issue.body, "Demo")
      end

      def cost
        extract_section(@issue.body, "Cost")
      end

      private
      def extract_section(lines, heading)
        in_section, body = false, ""
        regexp_in  = /^(\#+)\s+#{heading}/
        regexp_out = nil

        lines.split(/\r?\n/).each do |line|
          if regexp_in.match(line)
            level, in_section = $1.length, true
            regexp_out = /^\#{#{level}}\s+/
            next
          end

          in_section = false if in_section and regexp_out.match(line)
          body << line + "\n" if in_section
        end
        return body.to_s.gsub(/\r?\n/, ' ')
      end

      def adjust_indent(body)
        new_body = ""
        body.split(/\r?\n/).each do |line|
          line = "#####" + line if line =~ /^\#+/
          new_body << line + "\n"
        end
        return new_body
      end
    end # class Issue
  end # module Formatter
end # module Octaccord
