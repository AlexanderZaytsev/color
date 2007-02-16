# :title: Color -- Colour Management with Ruby
# :main: Readme.txt

#--
# Color
# Colour management with Ruby
# http://rubyforge.org/projects/color
#   Version 1.4.0
#
# Licensed under a MIT-style licence. See Licence.txt in the main
# distribution for full licensing information.
#
# Copyright (c) 2005 - 2007 Austin Ziegler and Matt Lyon
#
# $Id: test_all.rb 55 2007-02-03 23:29:34Z austin $
#++

# = Colour Management with Ruby
module Color
  COLOR_VERSION = '1.4.0'

  class RGB; end
  class CMYK; end
  class GrayScale; end
  class YIQ; end

  # The maximum "resolution" for colour math; if any value is less than or
  # equal to this value, it is treated as zero.
  COLOR_EPSILON = 1e-5
  # The tolerance for comparing the components of two colours. In general,
  # colours are considered equal if all of their components are within this
  # tolerance value of each other.
  COLOR_TOLERANCE = 1e-4

  class << self
    # Returns +true+ if the value is less than COLOR_EPSILON.
    def near_zero?(value)
      (value.abs <= COLOR_EPSILON)
    end

    # Returns +true+ if the value is within COLOR_EPSILON of zero or less than
    # zero.
    def near_zero_or_less?(value)
      (value < 0.0 or near_zero?(value))
    end

    # Returns +true+ if the value is within COLOR_EPSILON of one.
    def near_one?(value)
      near_zero?(value - 1.0)
    end

    # Returns +true+ if the value is within COLOR_EPSILON of one or more than
    # one.
    def near_one_or_more?(value)
      (value > 1.0 or near_one?(value))
    end

    # Normalizes the value to the range (0.0) .. (1.0).
    def normalize(value)
      if near_zero_or_less? value
        0.0
      elsif near_one_or_more? value
        1.0
      else
        value
      end
    end
  end
end

require 'color/rgb'
require 'color/cmyk'
require 'color/grayscale'
require 'color/hsl'
require 'color/yiq'
require 'color/rgb/metallic'

module Color
  def self.const_missing(name) #:nodoc:
    case name
    when "VERSION", :VERSION, "COLOR_TOOLS_VERSION", :COLOR_TOOLS_VERSION
      warn "Color::#{name} has been deprecated. Use Color::COLOR_VERSION instead."
      Color::COLOR_VERSION
    else
      if Color::RGB.const_defined?(name)
        warn "Color::#{name} has been deprecated. Use Color::RGB::#{name} instead."
        Color::RGB.const_get(name)
      else
        super
      end
    end
  end

  # Provides a thin veneer over the Color module to make it seem like this
  # is Color 0.1.0 (a class) and not Color 1.4.0 (a module). This
  # "constructor" will be removed in the future.
  #
  # mode = :hsl::   +values+ must be an array of [ hue deg, sat %, lum % ].
  #                 A Color::HSL object will be created.
  # mode = :rgb::   +values+ will either be an HTML-style colour string or
  #                 an array of [ red, green, blue ] (range 0 .. 255). A
  #                 Color::RGB object will be created.
  # mode = :cmyk::  +values+ must be an array of [ cyan %, magenta %, yellow
  #                 %, black % ]. A Color::CMYK object will be created.
  def self.new(values, mode = :rgb)
    warn "Color.new has been deprecated. Use Color::#{mode.to_s.upcase}.new instead."
    color = case mode
            when :hsl
              Color::HSL.new(*values)
            when :rgb
              values = [ values ].flatten
              if values.size == 1
                Color::RGB.from_html(*values)
              else
                Color::RGB.new(*values)
              end
            when :cmyk
              Color::CMYK.new(*values)
            end
    color.to_hsl
  end
end
