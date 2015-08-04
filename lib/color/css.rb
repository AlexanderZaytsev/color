# This namespace contains some CSS colour names.
module Colour::CSS
  # Returns the RGB colour for name or +nil+ if the name is not valid.
  def self.[](name)
    Colour::RGB.by_name(name) { nil }
  end
end
