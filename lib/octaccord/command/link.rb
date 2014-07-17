module Octaccord
  module Command
    class Link
      Encoding.default_external = "UTF-8"

      def initialize(stdin)
        while line = stdin.gets
          puts line.sub(/\#(\d+)/, '[#\1](../issues/\1)')
        end
      end
    end # class Link
  end # module Command
end # module Octaccord
