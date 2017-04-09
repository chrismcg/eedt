class Market

  COST = 5
  MAX_ACCEPTABLE_PRICE = COST * 10

  SUPPLY_INCREMENT = 80
  PRICE_INCREMENT = 1.1
  PRICE_DECREMENT = 0.9

  MAX_STARTING_PROFIT = 5
  MAX_STARTING_SUPPLY = 20

  attr_reader :producers
  attr_reader :consumers

  def initialize(producer_count, consumer_count)
    create_producers(producer_count)
    create_consumers(consumer_count)
  end

  def average_price
    (producers.inject(0.0) { |memo, producer| memo + producer.price}/producers.size).round(2)
  end

  def supply
    producers.inject(0) { |memo, producer| memo + producer.supply }
  end

  def demand
    consumers.inject(0) { |memo, consumer| memo + consumer.demands }
  end

  def cheapest_producer
    producers.find_all {|f| f.supply > 0}.min_by{|f| f.price}
  end

  private

  def create_consumers(consumer_count)
    @consumers = []
    consumer_count.times do |i|
      @consumers << Consumer.new(self, MAX_ACCEPTABLE_PRICE)
    end
  end

  def create_producers(producer_count)
    @producers = []
    producer_count.times do |i|
      producer = Producer.new(COST,
                              SUPPLY_INCREMENT,
                              PRICE_DECREMENT,
                              PRICE_INCREMENT)
      producer.price = COST + rand(MAX_STARTING_PROFIT)
      producer.supply = rand(MAX_STARTING_SUPPLY)
      @producers << producer
    end

  end
end

