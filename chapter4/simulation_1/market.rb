# frozen_string_literal: true

class Market

  COST = 5
  MAX_ACCEPTABLE_PRICE = COST * 10
  PRICE_DECREMENT = 0.9
  PRICE_INCREMENT = 1.1
  SUPPLY_INCREMENT = 80

  attr_reader :producers
  attr_reader :consumers

  def initialize(producer_count, consumer_count)
    create_producers(producer_count)
    create_consumers(consumer_count)
  end

  def average_price
    (producers.map(&:price).sum / producers.size.to_f).round(2)
  end

  def supply
    producers.map(&:supply).sum
  end

  def demand
    consumers.map(&:demands).sum
  end

  def cheapest_producer
    producers.find_all { |f| f.supply > 0 }.min_by(&:price)
  end

  def set_consumer_demands(simulation_iteration)
    consumers.each { |consumer| consumer.demands = ((Math.sin(simulation_iteration) + 2) * 20).round }
  end

  def set_producer_supply
    producers.each(&:produce)
  end

  def activate_consumers
    consumers.each(&:buy)
  end

  private

  def create_consumers(consumer_count)
    @consumers = []
    consumer_count.times do
      @consumers << Consumer.new(self, MAX_ACCEPTABLE_PRICE)
    end
  end

  def create_producers(producer_count)
    @producers = []
    producer_count.times do
      @producers << Producer.new(COST, SUPPLY_INCREMENT, PRICE_DECREMENT, PRICE_INCREMENT)
    end
  end
end
