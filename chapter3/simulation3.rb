# rubocop:disable Metrics/LineLength
require 'csv'
require './restroom'

day_length = 540
max_frequency = 5
max_number_of_restrooms = 1..4
facilities_per_restroom = 3
max_use_duration = 1
population_range = 10..600

chance_calculator = lambda do
  frequency = rand(max_frequency) + 1
  lambda do |time|
    if time > 270 && time < 390
      12 / day_length.to_f
    else
      (rand(frequency) + 1) / day_length.to_f
    end
  end
end

max_number_of_restrooms.each do |restroom_count|
  puts "Simulating #{restroom_count} restroom(s)"
  data = Hash.new { |h, population_size| h[population_size] = [] }

  population_range.step(10).each do |population_size|
    office = Office.new(
      population_size,
      restroom_count,
      facilities_per_restroom,
      max_use_duration,
      chance_calculator
    )

    day_length.times do |time|
      data[population_size] << office.queue_size
      office.tick(time)
    end
  end

  CSV.open("simulation3-#{restroom_count}.csv", 'w') do |csv|
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
end
