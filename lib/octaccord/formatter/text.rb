module Octaccord
  module Formatter
    class Text < Base
      private

      def format_frame_header ; ""; end
      def format_frame_footer ; ""; end

      def format_item(issue)
        issue.summary
      end
    end # class Text
  end # module Formatter
end # module Octaccord
