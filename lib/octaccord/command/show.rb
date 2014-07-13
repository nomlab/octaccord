module Octaccord
  module Command
    class Show

      def initialize(client, repos, issue_number, **options)
        begin
          issue = client.issue(repos, issue_number)
          formatter = Octaccord::Formatter.build(formatter: :list)
          formatter << issue
          print formatter.to_s
        rescue Octokit::ClientError => e
          STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
        end
      end
    end # class Show
  end # module Command
end # module Octaccord
