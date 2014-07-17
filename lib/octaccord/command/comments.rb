module Octaccord
  module Command
    class Comments

      def initialize(client, repos, since, before)
        begin
          comments = client.issues_comments(repos, :since => since)
          comments.each do |comment|
            next if comment.updated_at > before
            issue = comment.rels[:issue].get.data
            formatter = Octaccord::Formatter.build(formatter: :list)
            formatter << issue
            print formatter.to_s
            lines = Formatter::Comment.new(comment).adjust_indent.split(/\r?\n/)
            print "  * "
            print lines.first.sub(/^#+\s*/, '')
            print "..." if lines.length > 1
            print "[...](#{comment.html_url})"
            print "\n"
          end
          print "\n"
          # issue = client.issue(repos, issue_number)
        rescue Octokit::ClientError => e
          STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
        end
      end
    end # class Comments
  end # module Command
end # module Octaccord
