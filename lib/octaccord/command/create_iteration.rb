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
        template = ERB.new(content)
        options.delete(:template)
        itr = Octaccord::Iteration.new(name: name, **options)
        puts template.result(binding)
      end
    end # class CreateIteration
  end # module Command
end # module Octaccord
