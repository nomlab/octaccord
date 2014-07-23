module Octaccord
  module Command
    class Scan
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, replace = nil, **options)
        formatter = Octaccord::Formatter.build(formatter: options[:format] || :text)
        if query = options[:search]
          items = search(client, repos, query, formatter)
        else
          items = scan(client, repos, options[:type], formatter)
        end
        format(items, formatter, replace)
      end

      def search(client, repos, query, formatter)
        # https://help.github.com/articles/searching-issues
        # or issues = client.list_issues(repos)
        # type:issue means ignore pull request
        query = "repo:#{repos} #{query}"
        query << " state:open" unless query =~ /state:/
        query << " type:issue" unless query =~ /type:/
        STDERR.puts "Query: #{query}" if $OCTACCORD_DEBUG

        if query =~ /(-)?refers:\(([^)]+)\)/
          negop, subquery = $1, $2
          query = query.sub(/(-)?refers:\([^)]+\)/, "")
          subquery << " repo:#{repos}"
          subquery << " state:open" unless subquery =~ /state:/
          subquery << " type:issue" unless subquery =~ /type:/
          puts "SUBQUERY: #{subquery}" if $OCTACCORD_DEBUG
          subitems = client.search_issues(subquery).items
          puts "QUERY: #{query}" if $OCTACCORD_DEBUG
          issues = client.search_issues(query).items
          refers(subitems, issues, (negop == "-"))
        else
          issues = client.search_issues(query).items
        end
      end

      def scan(client, repos, type, formatter)
        if type == "pr"
          issues = client.issues(repos).select{|issue| issue.pull_request}
        else
          issues = client.issues(repos).select{|issue| not issue.pull_request}
        end
      end

      def refers(parents, issues, negop)
        if $OCTACCORD_DEBUG
          STDERR.puts "* NEGOP: #{negop}"
          STDERR.puts "* BEGIN parents ********************************************"
          STDERR.puts parents.map{|i| i.number}.join(',')
          STDERR.puts "* END parents ********************************************"
          STDERR.puts "* BEGIN issues *********************************************"
          STDERR.puts issues.map{|i| i.number}.join(',')
          STDERR.puts "* END issues *********************************************"
        end

        children = []

        parents.each do |parent|
          STDERR.puts "ABOUT PARENT #{parent.number}:" if $OCTACCORD_DEBUG
          issues.each do |issue|
            Octaccord::Formatter::Issue.new(issue).references.each do |refer_num|
              STDERR.puts "  REFER #{issue.number} refers #{refer_num}" if $OCTACCORD_DEBUG
              if parent.number.to_i == refer_num
                STDERR.puts "FOUND #{refer_num}" if $OCTACCORD_DEBUG
                children << issue
              end
            end
          end
        end
        children.uniq!

        if negop
          return issues - children
        else
          return children
        end
      end

      def format(issues, formatter, replace = nil)
        issues.each do |issue|
          formatter << issue
        end
        formatter.order(replace) if replace
        print formatter.to_s
      end

    end # class Scan
  end # module Command
end # module Octaccord
