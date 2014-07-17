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

      def order(numbers)
        numbers = scan_issue_numbers_from_string(numbers) if numbers.is_a?(String)

        ordered = numbers.map do |n|
          @issues.find{|issue| issue.number.to_i == n}
        end.compact

        @issues = ordered + (@issues - ordered)
      end

      def to_s
        format_frame_header +
          format_header +
          format_body +
          format_footer +
          format_frame_footer
      end

      private

      def scan_issue_numbers_from_string(string, one_for_each_line = true)
        regexp = one_for_each_line ? /#(\d+).*\n?/ : /#(\d+)/
        string.scan(regexp).map{|i| i.first.to_i}
      end

      def format_body
        @issues.map{|issue| format_item(issue)}.compact.join("\n") + "\n"
      end

      def format_frame_header
        ""
      end

      def format_frame_footer
        ""
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
