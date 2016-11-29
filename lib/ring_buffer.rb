require_relative "static_array"
require 'byebug'
class RingBuffer
  attr_reader :length

  def initialize
    @length = 0
    @start_idx = 0
    @capacity = 8
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    check_index(index)
    self.store[(index + self.start_idx) % capacity]
  end

  # O(1)
  def []=(index, val)
    self.store[(index + self.start_idx) % capacity] = val
  end

  # O(1)
  def pop
    val = self[self.length-1]
    self[self.length-1] = nil
    self.length -= 1
    val
  end

  # O(1) ammortized
  def push(val)
    self.resize! if self.length == self.capacity
    self[self.length] = val
    self.length += 1
    nil
  end

  # O(1)
  def shift
    raise "index out of bounds" if self.length <= 0
    val = self[0]
    self[0] = nil;
    self.start_idx = ((self.start_idx+1) % self.capacity)
    self.length -=  1
    val
  end

  # O(1) ammortized
  def unshift (val)
    self.resize! if self.length == self.capacity
    self.start_idx = ((self.start_idx-1) % self.capacity)
    self.length += 1
    self[0] = val;
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    if index < 0 || index >= self.length
      raise "index out of bounds"
    end
  end

  def resize!
    self.capacity
    newStore = StaticArray.new(self.capacity*2)
    self.length.times{|i| newStore[i] = self[i]}
    self.capacity *= 2
    self.store = newStore
    self.start_idx = 0
  end
end
