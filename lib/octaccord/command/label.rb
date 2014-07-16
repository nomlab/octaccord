module Octaccord
  module Command
    class Label

      def initialize(client, repos, **options)
        begin
          client.labels(repos).each do |label|
            puts label.name
          end
        rescue Octokit::ClientError => e
          STDERR.puts "Error: ##{issue} -- #{e.message.split(' // ').first}"
        end
      end
    end # class Label
  end # module Command
end # module Octaccord
