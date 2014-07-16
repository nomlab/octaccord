module Octaccord
  module Command
    class Show

      def initialize(client, repos, issue_number, **options)
        begin
          comments = client.issues_comments(repos, :since => Date.today - 14)
          comments.each do |comment|
            issue = comment.rels[:issue].get.data
            formatter = Octaccord::Formatter.build(formatter: :text)
            formatter << issue
            print "* "
            print formatter.to_s
            print "  * "
            lines = Formatter::Comment.new(comment).adjust_indent.split(/\r?\n/)
            print lines.first.sub(/^#+\s*/, '')
            print "..." if lines.length > 1
            print "[>>](#{comment.html_url})"
            print "\n"
          end
          # issue = client.issue(repos, issue_number)
        rescue Octokit::ClientError => e
          STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
        end
      end
    end # class Show
  end # module Command
end # module Octaccord
