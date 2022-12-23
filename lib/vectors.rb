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

  def subtract_until_at_edge(vector1, step)
    sum = vector1.dup
    sum = subtract(sum, step) while subtract(sum, step)[0].between?(0, 7) && subtract(sum, step)[1].between?(0, 7)
    sum
  end
end
