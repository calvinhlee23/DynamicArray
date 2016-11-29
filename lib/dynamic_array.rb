require_relative "static_array"
require 'byebug';
class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8;
    @store = StaticArray.new(0)
  end

  # O(1)
  def [](index)
    if @length == 0
      raise "index out of bounds"
    elsif index > @length-1
      raise "index out of bounds"
    else
      self.store[index]
    end
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  # O(1)
  def pop
    if self.length == 0
      raise "index out of bounds"
    end
    index = self.length-1
    value = self.store[index]
    self.store[index] = nil
    self.length -= 1
    value
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if self.length == self.capacity
      self.capacity *= 2;
      newStore = StaticArray.new(self.capacity);
      i = 0
      while i < self.length
        newStore[i] = self.store[i]
        i += 1
      end
      self.store = newStore
    end

    self[self.length] = val;
    self.length += 1
    self.store
  end

  # O(n): has to shift over all the elements.
  def shift
    if self.length == 0
      raise "index out of bounds"
    end
    val = self[0]
    newStore = StaticArray.new(self.capacity)
    i = 1
    while i < self.length
      newStore[i-1] = self[i]
      i+=1
    end
    self.length -= 1
    self.store = newStore
    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if self.length == self.capacity
      self.capacity *= 2;
    end
    newStore = StaticArray.new(self.capacity);
    newStore[0] = val
    i = 0
    while i < self.length
      newStore[i+1] = self[i]
      i+=1
    end
    self.length +=1;
    self.store = newStore

  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
  end
end
