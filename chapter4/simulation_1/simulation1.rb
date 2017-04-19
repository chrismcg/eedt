require 'csv'
require_relative 'consumer'
require_relative 'producer'
require_relative 'market'

NUM_OF_CONSUMERS = 10
NUM_OF_PRODUCERS = 10
SIMULATION_DURATION = 150

def write(name, data, variable_names = [])
  CSV.open("analysis/#{name}.csv", 'w') do |csv|
    csv << variable_names
    data.each do |row|
      csv << row
    end
  end
end


market = Market.new(NUM_OF_PRODUCERS, NUM_OF_CONSUMERS)

demand_supply = []
price_demand = []

SIMULATION_DURATION.times do |t|
  market.set_consumer_demands(t)

  demand_supply << [t, market.demand, market.supply]

  market.set_producer_supply

  price_demand << [t, market.average_price, market.demand]

  market.activate_consumers until market.demand == 0 || market.supply == 0
end

write('demand_supply', demand_supply, %w[Time Demand Supply])
write('price_demand', price_demand, %w[Time Average_Price Demand])
