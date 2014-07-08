module Octaccord
  module Command
    class Scan
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, **options)
        formatter = Octaccord::Formatter.build(formatter: options[:format] || :text)
        if query = options[:search]
          items = search(client, repos, query, formatter)
        else
          items = scan(client, repos, options[:type], formatter)
        end
        format(items, formatter)
      end

      def search(client, repos, query, formatter)
        # https://help.github.com/articles/searching-issues
        # or issues = client.list_issues(repos)
        # type:issue means ignore pull request
        query = "repo:#{repos} #{query}"
        query << " state:open" unless query =~ /state:/
        query << " type:issue" unless query =~ /type:/
        issues = client.search_issues(query).items
      end

      def scan(client, repos, type, formatter)
        if type == "pr"
          issues = client.issues(repos).select{|issue| issue.pull_request}
        else
          issues = client.issues(repos).select{|issue| not issue.pull_request}
        end
      end

      def format(issues, formatter)
        issues.each do |issue|
          formatter << issue
        end
        print formatter.to_s
      end

    end # class Scan
  end # module Command
end # module Octaccord
