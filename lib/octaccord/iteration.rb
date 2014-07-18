require "time"

module Octaccord
  class Iteration
    attr_accessor :name, :start, :due, :manager

    def initialize(name: name, manager: manager, start: start, due: due, team: team)
      if /([^\d]+)(\d+)/ =~ name
        @prefix, @number = $1, $2.to_i
      end
      @manager   = manager
      @team      = team
      self.start = start
      self.due   = due
    end

    def name(offset = 0)
      @prefix + format("%04d", @number + offset)
    end

    def start=(time)
      @start = Time.parse(time.to_s)
    end

    def due=(time)
      @due   = Time.parse(time.to_s)
    end

    def start_date
      @start.strftime("%Y-%m-%d")
    end

    def due_date
      @due.strftime("%Y-%m-%d")
    end

    def start
      @start.iso8601
    end

    def due
      @due.iso8601
    end

    def prev
      self.class.new(name: name(-1), manager: @manager, start: @start, due: @due)
    end

    def next
      self.class.new(name: name(+1), manager: @manager, start: @start, due: @due)
    end
  end # class Iteration
end # module Octaccord
