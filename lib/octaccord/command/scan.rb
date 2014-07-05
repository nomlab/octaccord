module Octaccord
  module Command
    class Scan
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, range = :all, format = :pbl)
        formatter = Octaccord::Formatter.build(formatter: format)
        scan(client, repos, range, formatter)
      end

      def scan(client, repos, range, formatter)
        issues = client.list_issues(repos)
        pp issues
        issues.each do |issue|
          next if issue.pull_request # we don't care about PR
          formatter << issue
        end
        print formatter.to_s
      end
    end # class Scan
  end # module Command
end # module Octaccord
