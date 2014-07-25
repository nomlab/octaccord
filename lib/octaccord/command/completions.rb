module Octaccord
  module Command
    class Completions

      def initialize(help, global_options, arguments)
        command_name = arguments.first

        if command_name and help[command_name]
          options(help, global_options, command_name)
        else
          commands(help)
        end
      end

      private

      def commands(help)
        puts "_values"
        puts "Sub-commands:"
        puts "help[Available commands or one specific COMMAND]"

        help.each do |name, option|
          next if name == "completions"
          puts "#{name}[#{option.description}]"
        end
      end

      def options(help, global_options, command_name)
        print "_arguments\n-A\n*\n"
        options = help[command_name].options.merge(global_options)

        options.each do |name, opt|
          if opt.type == :boolean
            print "(--#{name})--#{name}[#{opt.description}]\n"
          else
            print "(--#{name})--#{name}=-[#{opt.description}]:#{opt.banner}:#{possible_values(opt)}\n"
          end
        end
      end

      def possible_values(option)
        return "(" + option.enum.join(" ") + ")" if option.enum

        case option.banner
        when "FILE"
          "_files"
        when "DIRECTORY"
          "_files -/"
        else
          ""
        end
      end

    end # class Completions
  end # module Command
end # module Octaccord
