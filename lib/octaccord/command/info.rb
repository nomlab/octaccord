require "rugged"

module Octaccord
  module Command
    class Info

      def initialize(client, **options)
        begin
          repo = Rugged::Repository.discover(".")
          url = repo.remotes.find {|remote| remote.url =~ /github\.com/}.url
          puts url
        rescue Rugged::RepositoryError => e
          STDERR.print "Error: you are not in github repository.\n"
        end
      end
    end # class Info
  end # module Command
end # module Octaccord
