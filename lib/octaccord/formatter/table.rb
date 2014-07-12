module Octaccord
  module Formatter
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
  end # module Formatter
end # module Octaccord
