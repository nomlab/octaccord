module Octaccord
  module Formatter
    class Issue
      def initialize(issue)
        @resource = issue
      end

      def status
        return ":parking:" if labels =~ /PBL/
        # return ":white_check_mark:" if @resource.state == "closed"
        return ":arrow_upper_left:" if @resource.pull_request
        return avatar if @resource.assignee
        days = ((Time.now - @resource.updated_at) / (24*3600)).to_i
        return ":ghost:" if days > 60
        return ":grey_question:"
      end

      def avatar
        if @resource.assignee
          return "![#{@resource.assignee.login}](#{@resource.assignee.avatar_url}s=20)"
        else
          return ":grey_question:"
          octcat = "https://assets-cdn.github.com/images/gravatars/gravatar-user-420.png"
          gravatar = "https://www.gravatar.com/avatar/00000000000000000000000000000000"
          return "![not assigned](#{gravatar}?d=#{URI.encode_www_form_component(octcat)}&r=x&s=10)"
        end
      end

      def pr
        if @resource.pull_request then ":arrow_upper_left:" else nil end
      end

      def references
        @resource.body.scan(/#(\d+)/).map{|d| d.first.to_i}
      end

      def summary
        "##{@resource.number} #{@resource.title}" + (labels != "" ? " (#{labels})" : "")
      end

      def link
        type = if @resource.pull_request then "pull" else "issues" end
        "[##{@resource.number}](../#{type}/#{@resource.number} \"#{@resource.title}\")"
      end

      def number
        "#{@resource.number}"
      end

      def plain_link
        type = if @resource.pull_request then "pull" else "issues" end
        "[##{@resource.number}](../#{type}/#{@resource.number})"
      end

      def comments
        # https://github.com/octokit/octokit.rb#uri-templates
        comments = []

        STDERR.puts "* issue comments: #{@resource.rels[:comments].href}"

        @resource.rels[:comments].get.data.each do |c|
          comments << adjust_indent(c.body)
        end
        return comments.join
      end

      def title
        if @resource.state == "closed" then "~~#{@resource.title}~~" else @resource.title end
      end

      def labels
        @resource.labels.map{|label| label.name}.join(',')
      end

      def milestone
        if @resource.milestone then "#{@resource.milestone.title}" else nil end
      end

      def created_at
        @resource.created_at.localtime
      end

      def updated_at
        @resource.updated_at.localtime
      end

      def story
        extract_section(@resource.body, "Story")
      end

      def demo
        extract_section(@resource.body, "Demo")
      end

      def cost
        extract_section(@resource.body, "Cost")
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
