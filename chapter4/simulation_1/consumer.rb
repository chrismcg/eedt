class Consumer
  attr_accessor :demands

  attr_reader :max_acceptable_price
  attr_reader :market

  def initialize(market, max_acceptable_price)
    @demands = 0
    @max_acceptable_price = max_acceptable_price
    @market = market
  end

  def buy
    until @demands <= 0 or market.supply <= 0
      cheapest_producer = market.cheapest_producer
      if cheapest_producer
        @demands *= 0.5 if cheapest_producer.price > max_acceptable_price
        cheapest_supply = cheapest_producer.supply
        if @demands > cheapest_supply
          @demands -= cheapest_supply
          cheapest_producer.supply = 0
        else
          cheapest_producer.supply -= @demands
          @demands = 0
        end
      end
    end
  end
end

