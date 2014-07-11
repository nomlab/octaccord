module Octaccord
  module Command
    class UpdateIssues
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, issues, **options)
        labels = options[:labels]
        title, body = nil, nil # not update

        issues.each do |issue|
          begin
            response = client.ext_update_issue(repos, issue, {:labels => labels.split(',')})
            pp response if options[:debug]
          rescue Octokit::ClientError => e
            STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
          end
        end
      end
    end # class UpdateIssues
  end # module Command
end # module Octaccord
