module Octaccord
  module Command
    class UpdateIssues
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, issues, **options)
        issues.each do |issue|
          number = issue.to_i
          begin
            if label = options[:add_label]
              response = client.add_labels_to_an_issue(repos, number, [label])
              pp response if options[:debug]
              puts "Add label #{label} to ##{number}."
            end

            if label = options[:remove_label]
              response = client.remove_label(repos, number, label)
              pp response if options[:debug]
              puts "Remove label #{label} from ##{number}."
            end
          rescue Octokit::ClientError => e
            STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
          end
        end
      end
    end # class UpdateIssues
  end # module Command
end # module Octaccord
