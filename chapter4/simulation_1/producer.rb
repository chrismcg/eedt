class Producer
  attr_accessor :supply
  attr_accessor :price
  attr_accessor :supply_increment
  attr_accessor :price_decrement
  attr_accessor :price_increment
  attr_accessor :cost

  def initialize(cost, supply_increment, price_decrement, price_increment)
    @supply, @price = 0, 0
    @cost = cost
    @supply_increment = supply_increment
    @price_decrement = price_decrement
    @price_increment = price_increment
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

