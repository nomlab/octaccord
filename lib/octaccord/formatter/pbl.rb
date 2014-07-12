module Octaccord
  module Formatter
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
  end # module Formatter
end # module Octaccord
