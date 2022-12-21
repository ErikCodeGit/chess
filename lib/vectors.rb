# frozen_string_literal: true

module Vectors
  def add(vector1, vector2)
    result = vector1.dup
    vector1.length.times do |i|
      result[i] += vector2[i]
    end
    result
  end

  def subtract(vector1, vector2)
    result = vector1.dup
    vector1.length.times do |i|
      result[i] -= vector2[i]
    end
    result
  end
end
