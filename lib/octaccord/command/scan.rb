module Octaccord
  module Command
    class Scan
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, range = :all, **options)
        formatter = Octaccord::Formatter.build(formatter: options[:format] || :text)
        scan(client, repos, range, options[:search], formatter)
      end

      def scan(client, repos, range, search, formatter)
        # https://help.github.com/articles/searching-issues
        # or issues = client.list_issues(repos)
        # type:issue means ignore pull request

        query = "repo:#{repos} #{search}"
        query << " state:open" unless search =~ /state:/
        query << " type:issue" unless search =~ /type:/
        issues = client.search_issues(query).items

        issues.each do |issue|
          formatter << issue
        end
        print formatter.to_s
      end
    end # class Scan
  end # module Command
end # module Octaccord
