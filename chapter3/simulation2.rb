# rubocop:disable Metrics/LineLength, Style/Documentation
require 'csv'
require './restroom'

day_length = 540
frequency = 3.0
chance = frequency / day_length
use_duration = 1
population_size = 1000
restroom_count = 1
facilities_per_restroom_range = 1..30

data = Hash.new { |h, facilities_per_restroom| h[facilities_per_restroom] = [] }

facilities_per_restroom_range.each do |facilities_per_restroom|
  puts "Simulating #{facilities_per_restroom} facilities"

  office = Office.new(
    population_size,
    restroom_count,
    facilities_per_restroom,
    use_duration,
    chance
  )

  day_length.times do |time|
    data[facilities_per_restroom] << office.queue_size
    office.tick(time)
  end
end

CSV.open('simulation2.csv', 'w') do |csv|
  labels = []
  facilities_per_restroom_range.each { |facilities_per_restroom| labels << facilities_per_restroom }

  csv << labels
  day_length.times do |t|
    row = []
    facilities_per_restroom_range.each do |facilities_per_restroom|
      row << data[facilities_per_restroom][t]
    end
    csv << row
  end
end
