# frozen_string_literal: true

module Helper
  def opposite_color(color)
    case color
    when :white
      :black
    when :black
      :white
    end
  end
end
