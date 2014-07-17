module Octaccord
  class Iteration
    attr_accessor :name, :start, :due, :manager

    def initialize(name: name, manager: manager, start: start, due: due)
      if /([^\d]+)(\d+)/ =~ name
        @prefix, @number = $1, $2.to_i
      end
      @manager, @start, @due = manager, start, due
    end

    def name(offset = 0)
      @prefix + format("%04d", @number + offset)
    end

    def prev
      self.class.new(name: name(-1), manager: @manager, start: @start, due: @due)
    end

    def next
      self.class.new(name: name(+1), manager: @manager, start: @start, due: @due)
    end
  end # class Iteration
end # module Octaccord
