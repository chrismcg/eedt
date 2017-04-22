# This simulation shows what resources are required for different levels of
# customers. Customers are in different timezones and use the product during
# their day
require 'csv'
require_relative './models'

products = [
  Product.new('Product 1', compute: 2, writes: 5, reads: 50)
]
# repeat timezone to weight them so more customers end up in certain ones.
timezones = %w(
  Europe/Dublin
  Europe/Dublin
  Europe/Dublin
  Europe/Paris
  Europe/Paris
  America/Los_Angeles
  America/Los_Angeles
  America/New_York
  America/New_York
  Australia/Sydney
)

max_customers = 200

results = Hash.new do |h, customer_count|
  h[customer_count] = { compute: [], writes: [], reads: [] }
end

10.step(by: 10, to: max_customers) do |customer_count|
  rng = Random.new(1234)
  customers = Array.new(customer_count) do
    Customer.new(products, timezones.sample(random: rng))
  end

  24.times do |hour|
    total_compute = total_writes = total_reads = 0
    time = Time.new(2017, 1, 1, hour)

    customers.each do |customer|
      compute, writes, reads = customer.usage(time)
      total_compute += compute
      total_writes += writes
      total_reads += reads
    end

    results[customer_count][:compute] << total_compute
    results[customer_count][:writes] << total_writes
    results[customer_count][:reads] << total_reads
  end
end

%i(compute writes reads).each do |type|
  CSV.open("simulation1-#{type}.csv", 'wb') do |csv|
    csv << results.keys

    24.times do |hour|
      row = results.keys.map { |customer_count| results[customer_count][type][hour] }
      csv << row
    end
  end
end
