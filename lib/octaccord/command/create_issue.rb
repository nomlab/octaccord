module Octaccord
  module Command
    class CreateIssue
      Encoding.default_external = "UTF-8"

      def initialize(client, repo, title, body, **options)
        begin
          client.create_issue(repo, title, body, **options) 
        rescue Octokit::ClientError => e
          STDERR.puts "Error: #{e.message.split(' // ').first}"
        end
      end
    end # class CreateIssue
  end # module Command
end # module Octaccord
