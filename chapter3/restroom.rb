# rubocop:disable Metrics/LineLength, Style/Documentation

class Person
  attr_reader :duration
  attr_reader :use_duration
  attr_reader :chance
  attr_reader :restroom
  attr_reader :facility
  attr_reader :occupy_time
  attr_reader :time

  def initialize(use_duration, chance)
    @use_duration = use_duration
    @chance = chance.respond_to?(:call) ? chance.call : chance
    @time = 0
  end

  def need_to_go?(time)
    current_chance = chance.respond_to?(:call) ? chance.call(time) : chance
    rand < current_chance
  end

  def go_to_restroom(restrooms)
    restroom = restrooms.min_by(&:queue_size)
    facility = restroom.facilities.find(&:free?)
    if facility
      occupy(restroom, facility)
    else
      enter_queue(restroom)
    end
  end

  def occupy(restroom, facility)
    @occupy_time = time
    @in_queue = false
    @using = true
    @restroom = restroom
    @facility = facility
    restroom.leave_queue(self)
    facility.occupy(self)
  end

  def enter_queue(restroom)
    @in_queue = true
    @using = false
    @restroom = restroom
    restroom.enter_queue(self)
    @facility = nil
  end

  def vacate
    facility.vacate
    @duration = nil
    @in_queue = false
    @using = false
    @restroom = nil
  end

  def finished?
    if using?
      duration = time - occupy_time
      duration >= use_duration
    else
      false
    end
  end

  def using?
    @using
  end

  def queuing?
    @in_queue
  end

  def tick(restrooms, time)
    @time = time
    if using?
      vacate if finished?
    elsif queuing?
      # This means the queue might not be "fair" / fifo but that doesn't matter
      # for the purposes of this simulation. Could yield here and let the
      # controlling simulation "tick" the restrooms in order to work round this.
      facility = restroom.facilities.find(&:free?)
      occupy(restroom, facility) if facility
    elsif need_to_go?(time)
      go_to_restroom(restrooms)
    end
  end
end

class Facility
  attr_reader :restroom
  attr_reader :occupier

  def initialize(restroom)
    @restroom = restroom
  end

  def occupy(person)
    @occupier = person
  end

  def vacate
    @occupier = nil
  end

  def occupied?
    !@occupier.nil?
  end

  def free?
    @occupier.nil?
  end
end

class Restroom
  attr_reader :facilities
  attr_reader :queue

  def initialize(facility_count)
    @facilities = Array.new(facility_count) { Facility.new(self) }
    @queue = []
  end

  def queue_size
    queue.size
  end

  def enter_queue(person)
    queue << person
  end

  def leave_queue(person)
    queue.delete(person)
  end
end

class Office
  attr_reader :population
  attr_reader :restrooms

  def initialize(population_size, restroom_count, facilities_per_restroom, use_duration, chance)
    @population = Array.new(population_size) { Person.new(use_duration, chance) }
    @restrooms = Array.new(restroom_count) { Restroom.new(facilities_per_restroom) }
  end

  def queue_size
    population.count(&:queuing?)
  end

  def tick(time)
    population.each { |p| p.tick(restrooms, time) }
  end
end

if __FILE__ == $PROGRAM_NAME
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  require 'test/unit'

  class TestPerson < Test::Unit::TestCase
    def setup
      @duration = 1
      @normal_chance = 3.0 / 540
      @full_chance = 1.0
      @no_chance = 0.0
      @time = 1
      @restroom = Restroom.new(1)
      @facility = @restroom.facilities.first
    end

    def test_tick_when_facility_empty
      person1 = Person.new(@duration, @full_chance)
      assert @restroom.queue_size.zero?
      assert @facility.free?

      person1.tick([@restroom], @time)
      assert @restroom.queue_size.zero?
      assert @facility.occupied?
      assert person1.using?
    end

    def test_tick_when_person_finished
      person1 = Person.new(@duration, @full_chance)
      person1.occupy(@restroom, @facility)

      person1.tick([@restroom], @time)
      assert @restroom.queue_size.zero?
      refute @facility.occupied?
      refute person1.using?
    end

    def test_tick
      person1 = Person.new(@duration, @normal_chance)
      person1.occupy(@restroom, @facility)
      assert @facility.occupied?
      refute person1.queuing?
      assert person1.using?

      person2 = Person.new(@duration, @normal_chance)
      person2.enter_queue(@restroom)
      assert_equal 1, @restroom.queue_size
      assert person2.queuing?
      refute person2.using?

      person3 = Person.new(@duration, @full_chance)
      person4 = Person.new(@duration, @no_chance)

      people = [person1, person2, person3, person4]

      people.each { |person| person.tick([@restroom], @time) }

      refute person1.queuing?
      refute person1.using?
      refute person2.queuing?
      assert person2.using?
      assert person3.queuing?
      refute person3.using?
      refute person4.queuing?
      refute person4.using?
    end
  end
end
