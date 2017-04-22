# This file holds the models for the usage simulation
require 'tzinfo'

class Product
  attr_reader :name
  attr_reader :compute
  attr_reader :writes
  attr_reader :reads

  def initialize(name, compute: 0, writes: 0, reads: 0)
    @name = name
    @compute = compute
    @writes = writes
    @reads = reads
  end
end

class Customer
  attr_reader :products
  attr_reader :timezone

  def initialize(products, timezone)
    @products = products
    @timezone = TZInfo::Timezone.get(timezone)
  end

  def usage(time)
    local_hour = timezone.utc_to_local(time).hour
    if local_hour > 9 && local_hour < 17
      # while customer is at work they use a random amount of the max resources
      # for the product
      compute = products.map(&:compute).map { |value| rand(value) + 1 }.sum
      writes = products.map(&:writes).map { |value| rand(value) + 1 }.sum
      reads = products.map(&:reads).map { |value| rand(value) + 1 }.sum
      [compute, writes, reads]
    else
      [0, 0, 0]
    end
  end
end
