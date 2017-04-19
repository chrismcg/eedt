class Producer
  attr_accessor :cost
  attr_accessor :price
  attr_accessor :price_decrement
  attr_accessor :price_increment
  attr_accessor :supply
  attr_accessor :supply_increment

  MAX_STARTING_PROFIT = 5
  MAX_STARTING_SUPPLY = 20

  def initialize(cost, supply_increment, price_decrement, price_increment)
    @supply = 0
    @price = 0
    @cost = cost
    @supply_increment = supply_increment
    @price_decrement = price_decrement
    @price_increment = price_increment

    @price = cost + rand(MAX_STARTING_PROFIT)
    @supply = rand(MAX_STARTING_SUPPLY)
  end

  def generate_goods
    @supply += supply_increment if @price > cost
  end

  def produce
    if @supply > 0
      @price *= price_decrement unless @price < cost
    else
      @price *= price_increment
      generate_goods
    end
  end
end
