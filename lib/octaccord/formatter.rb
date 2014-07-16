module Octaccord
  module Formatter

    class FormatterNameError < StandardError; end

    def self.build(formatter: :text)
      formatters = {
        :debug  => Debug,
        :list   => List,
        :number => Number,
        :pbl    => Pbl,
        :table  => Table,
        :text   => Text
      }
      formatter = formatter.to_sym
      return formatters[formatter].new if formatters[formatter]
      raise FormatterNameError.new("Unknown format: #{formatter}")
    end

    class Base
      def initialize
        @issues = []
      end

      def <<(issue)
        @issues << Issue.new(issue)
      end

      def to_s
        format_frame_header +
          format_header +
          format_body +
          format_footer +
          format_frame_footer
      end

      private

      def format_body
        @issues.map{|issue| format_item(issue)}.compact.join("\n") + "\n"
      end

      def format_frame_header
        "<!-- begin:octaccord #{self.class.name} -->\n"
      end

      def format_frame_footer
        "\n<!-- end:octaccord #{self.class.name} -->\n"
      end

      def format_header ;""; end
      def format_footer ;""; end
    end # class Base

    dir = File.dirname(__FILE__) + "/formatter"
    autoload :Comment,    "#{dir}/comment.rb"
    autoload :Debug,      "#{dir}/debug.rb"
    autoload :List,       "#{dir}/list.rb"
    autoload :Number,     "#{dir}/number.rb"
    autoload :Pbl,        "#{dir}/pbl.rb"
    autoload :Table,      "#{dir}/table.rb"
    autoload :Text,       "#{dir}/text.rb"

    autoload :Issue,      "#{dir}/issue.rb"

  end # module Formatter
end # module Octaccord
