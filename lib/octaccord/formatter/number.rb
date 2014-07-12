module Octaccord
  module Formatter
    class Number < Base
      private

      def format_frame_header ; ""; end
      def format_frame_footer ; ""; end

      def format_item(issue)
        issue.number
      end
    end # class Number
  end # module Formatter
end # module Octaccord
