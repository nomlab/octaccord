module Octaccord
  module Command
    class Scan
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, replace = nil, **options)
        if options[:format] == "json"
          formatter = nil
        else
          formatter = Octaccord::Formatter.build(formatter: options[:format] || :text)
        end
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

        if query =~ /(-)?(refers|refered):\(([^)]*)\)/
          negop, reftype, subquery = $1, $2, $3
          query = query.sub(/-?(refers|refered):\([^)]*\)/, "")

          subquery << " repo:#{repos}"
          subquery << " state:open" unless subquery =~ /state:/
          subquery << " type:issue" unless subquery =~ /type:/

          if $OCTACCORD_DEBUG
            STDERR.puts "SUBQUERY: #{subquery}"
            STDERR.puts "QUERY: #{query}"
          end

          subitems = client.search_issues(subquery).items
          issues = client.search_issues(query).items

          if reftype == "refers"
            return refers(subitems, issues, (negop == "-"))
          else
            return refered(issues, subitems, (negop == "-"))
          end
        end

        issues = client.search_issues(query).items
      end

      def scan(client, repos, type, formatter)
        if type == "pr"
          issues = client.issues(repos).select{|issue| issue.pull_request}
        else
          issues = client.issues(repos).select{|issue| not issue.pull_request}
        end
      end

      def refers(parents, issues, negop)
        parents, children = corss_reference(parents, issues, negop)
        return children
      end

      def refered(parents, issues, negop)
        parents, children = corss_reference(parents, issues, negop)
        return parents
      end

      def corss_reference(parents, children, negop)
        if $OCTACCORD_DEBUG
          STDERR.puts "* PARENTS: #{parents.map{|i| i.number}.join(', ')}"
          STDERR.puts "* CHILDREN: #{children.map{|i| i.number}.join(', ')}"
          STDERR.puts "* NEGOP: #{negop}"
        end

        refered_parents = []
        refering_children = []

        parents.each do |parent|
          STDERR.puts "ABOUT PARENT: #{parent.number}:" if $OCTACCORD_DEBUG
          children.each do |child|
            Octaccord::Formatter::Issue.new(child).references.each do |refer_num|
              STDERR.puts "  child #{child.number} refers #{refer_num} #{parent.number.to_i == refer_num ? " FOUND" : "" }" if $OCTACCORD_DEBUG
              if parent.number.to_i == refer_num
                STDERR.puts "FOUND #{refer_num}" if $OCTACCORD_DEBUG
                refered_parents << parent
                refering_children << child
              end
            end
          end
        end

        refered_parents.uniq!
        refering_children.uniq!

        if negop
          return [parents-refered_parents, children-refering_children]
        else
          return [refered_parents, refering_children]
        end
      end

      def format(issues, formatter, replace = nil)
        if formatter == nil # raw format
          print issues.to_s
          return
        end

        issues.each do |issue|
          formatter << issue
        end
        formatter.order(replace) if replace
        print formatter.to_s
      end

    end # class Scan
  end # module Command
end # module Octaccord
