module Octaccord
  module Formatter
    class List < Base
      private

      def format_item(issue)
        headline = "##### #{issue.link} #{issue.status} #{issue.title}\n#{issue.comments}"
      end
    end # class List
  end # module Formatter
end # module Octaccord
