# rubocop:disable Metrics/LineLength, Style/Documentation
require 'csv'
require './restroom'

day_length = 540
frequency = 3.0
chance = frequency / day_length
use_duration = 1
restroom_count = 1
facilities_per_restroom = 3
population_range = 10..600

data = Hash.new { |h, population_size| h[population_size] = [] }

population_range.step(10).each do |population_size|
  puts "Simulating #{population_size} people"
  office = Office.new(
    population_size,
    restroom_count,
    facilities_per_restroom,
    use_duration,
    chance
  )

  day_length.times do |time|
    data[population_size] << office.queue_size
    office.tick(time)
  end
end

CSV.open('simulation1.csv', 'w') do |csv|
  labels = []
  population_range.step(10).each { |population_size| labels << population_size }

  csv << labels
  day_length.times do |t|
    row = []
    population_range.step(10).each do |population_size|
      row << data[population_size][t]
    end
    csv << row
  end
end
