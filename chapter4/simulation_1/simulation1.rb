require 'csv'
require_relative 'consumer'
require_relative 'producer'
require_relative 'market'

SIMULATION_DURATION = 150
NUM_OF_PRODUCERS = 10
NUM_OF_CONSUMERS = 10

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

  market.consumers.each do |consumer|
    consumer.demands = ((Math.sin(t)+2)*20).round
  end

  demand_supply << [t, market.demand, market.supply]

  market.producers.each do |producer|
    producer.produce
  end
  
  price_demand << [t, market.average_price, market.demand]
  
  until market.demand == 0 or market.supply == 0 do
    market.consumers.each do |consumer|
      consumer.buy 
    end
  end
end

write('demand_supply', demand_supply, %w(Time Demand Supply))
write('price_demand', price_demand, %w(Time Average_Price Demand))
