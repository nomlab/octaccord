require "erb"

module Octaccord
  module Command
    class CreateIteration
      def initialize(client, repos, name, **options)
        if file = options[:template]
          content = File.open(file).read
        else
          content = gets(nil)
        end
        template = ERB.new(content, nil, "-")
        options.delete(:template)

        # binding itr, repos
        itr = Octaccord::Iteration.new(client: client, name: name, repository: repos, **options)
        puts template.result(binding)
      end
    end # class CreateIteration
  end # module Command
end # module Octaccord
