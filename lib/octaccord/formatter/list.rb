module Octaccord
  module Formatter
    class List < Base
      private

      def format_frame_footer
        "\n"
      end

      def format_item(issue, options = {})
        header = options[:header] || "*"
        comments = if options[:include_comments] then "\n" + issue.comments else "" end

        if issue.references.length > 0
          refs = " refs:#{issue.references.map{|i| number_link(i)}.join(",")}"
        else
          refs = ""
        end

        if issue.labels != ""
          labels = " labels:#{issue.labels}"
        else
          labels = ""
        end

        headline = "#{header} #{issue.link} #{issue.status} #{issue.title}#{refs}#{labels}#{comments}"
      end

      private
      def number_link(number)
        "[##{number}](../issues/#{number})"
      end

    end # class List
  end # module Formatter
end # module Octaccord
