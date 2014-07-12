module Octaccord
  module Formatter
    class Debug < Base
      private

      def format_frame_header ; ""; end
      def format_frame_footer ; ""; end

      def format_item(issue)
        "##{issue.number} #{issue.title} labels:#{issue.labels} ms:#{issue.milestone}" +
          " created_at:#{issue.created_at}" +
          " updated_at:#{issue.updated_at}" +
          " refs:#{issue.references.join(',')}"
      end
    end # class Debug
  end # module Formatter
end # module Octaccord
