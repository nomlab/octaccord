module Octaccord
  module Command
    class Scan
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, range = :all, format = :pbl)
        formatter = Octaccord::Formatter.build(formatter: format)
        scan(client, repos, range, formatter)
      end

      def scan(client, repos, range, formatter)
        # https://help.github.com/articles/searching-issues
        # or issues = client.list_issues(repos)
        # type:issue means ignore pull request
        issues = client.search_issues("repo:#{repos} type:issue state:open").items

        issues.each do |issue|
          formatter << issue
        end
        print formatter.to_s
      end
    end # class Scan
  end # module Command
end # module Octaccord
