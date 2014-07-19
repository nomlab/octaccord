module Octaccord
  module Command
    class Comments

      def initialize(client, repos, since, before)
        begin
          comments = client.issues_comments(repos, :since => since)
          issues = gather_issues(comments, before)

          issues.each do |uri, comments|
            next if comments.empty?
            issue = comments.first.rels[:issue].get.data
            print format_issue(issue)

            comments.each do |comment|
              print format_comment(comment)
            end
          end
          print "\n"
        rescue Octokit::ClientError => e
          STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
        end
      end
      private

      def gather_issues(comments, before)
        issues = {}

        comments.each do |comment|
          next if comment.updated_at > before
          uri = comment.rels[:issue].href
          issues[uri] ||= []
          issues[uri] << comment
        end
        return issues
      end

      def format_comment(comment)
        lines = Formatter::Comment.new(comment).adjust_indent.split(/\r?\n/)
        string = "  * "
        string << lines.first.sub(/^#+\s*/, '')
        string << "..." if lines.length > 1
        string << "[...](#{comment.html_url})"
        string << "\n"
      end

      def format_issue(issue)
        formatter = Octaccord::Formatter.build(formatter: :list)
        formatter << issue
        formatter.to_s
      end

    end # class Comments
  end # module Command
end # module Octaccord
