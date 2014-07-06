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
    end # class List

    class Pbl < Base
      private

      def format_header
          "| No.   | Title | Story | Demo  | Cost  |\n" +
          "| :---- | :---- | :---- | :---- | ----: |\n"
      end

      def format_item(issue)
        return nil unless issue.labels =~ /PBL/
        cols = []
        cols << "#{issue.link} #{issue.status}"
        cols << issue.title
        cols << " " # Story
        cols << " " # Demo
        cols << " " # Cost
        cols = "| " + cols.join(" | ") + " |"
      end
    end # class Pbl

    class List < Base
      private

      def format_item(issue)
        headline = "* #{issue.link} #{issue.status} #{issue.title}"
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

      def title
        if @issue.state == "closed" then "~~#{@issue.title}~~" else @issue.title end
      end

      def labels
        @issue.labels.map{|label| label.name}.join(',')
      end

      def milestone
        if @issue.milestone then "_#{@issue.milestone.title}_" else nil end
      end
    end # class Issue
  end # module Formatter
end # module Octaccord
