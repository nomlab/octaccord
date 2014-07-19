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
        headline = "#{header} #{issue.link} #{issue.status} #{issue.title}#{comments}"
      end
    end # class List
  end # module Formatter
end # module Octaccord
