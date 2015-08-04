# -*- ruby encoding: utf-8 -*-

require 'color'
require 'minitest_helper'

module TestColour
  class TestHSL < Minitest::Test
    def setup
#     @hsl = Colour::HSL.new(262, 67, 42)
      @hsl = Colour::HSL.new(145, 20, 30)
#     @rgb = Colour::RGB.new(88, 35, 179)
    end

    def test_rgb_roundtrip_conversion
      hsl = Colour::HSL.new(262, 67, 42)
      c = hsl.to_rgb.to_hsl
      assert_in_delta hsl.h, c.h, Colour::COLOR_TOLERANCE, "Hue"
      assert_in_delta hsl.s, c.s, Colour::COLOR_TOLERANCE, "Saturation"
      assert_in_delta hsl.l, c.l, Colour::COLOR_TOLERANCE, "Luminance"
    end

    def test_brightness
      assert_in_delta 0.3, @hsl.brightness, Colour::COLOR_TOLERANCE
    end

    def test_hue
      assert_in_delta 0.4027, @hsl.h, Colour::COLOR_TOLERANCE
      assert_in_delta 145, @hsl.hue, Colour::COLOR_TOLERANCE
      @hsl.hue = 33
      assert_in_delta 0.09167, @hsl.h, Colour::COLOR_TOLERANCE
      @hsl.hue = -33
      assert_in_delta 0.90833, @hsl.h, Colour::COLOR_TOLERANCE
      @hsl.h = 3.3
      assert_in_delta 360, @hsl.hue, Colour::COLOR_TOLERANCE
      @hsl.h = -3.3
      assert_in_delta 0.0, @hsl.h, Colour::COLOR_TOLERANCE
      @hsl.hue = 0
      @hsl.hue -= 20
      assert_in_delta 340, @hsl.hue, Colour::COLOR_TOLERANCE
      @hsl.hue += 45
      assert_in_delta 25, @hsl.hue, Colour::COLOR_TOLERANCE
    end

    def test_saturation
      assert_in_delta 0.2, @hsl.s, Colour::COLOR_TOLERANCE
      assert_in_delta 20, @hsl.saturation, Colour::COLOR_TOLERANCE
      @hsl.saturation = 33
      assert_in_delta 0.33, @hsl.s, Colour::COLOR_TOLERANCE
      @hsl.s = 3.3
      assert_in_delta 100, @hsl.saturation, Colour::COLOR_TOLERANCE
      @hsl.s = -3.3
      assert_in_delta 0.0, @hsl.s, Colour::COLOR_TOLERANCE
    end

    def test_luminance
      assert_in_delta 0.3, @hsl.l, Colour::COLOR_TOLERANCE
      assert_in_delta 30, @hsl.luminosity, Colour::COLOR_TOLERANCE
      @hsl.luminosity = 33
      assert_in_delta 0.33, @hsl.l, Colour::COLOR_TOLERANCE
      @hsl.l = 3.3
      assert_in_delta 100, @hsl.lightness, Colour::COLOR_TOLERANCE
      @hsl.l = -3.3
      assert_in_delta 0.0, @hsl.l, Colour::COLOR_TOLERANCE
    end

    def test_html_css
      assert_equal "hsl(145.00, 20.00%, 30.00%)", @hsl.css_hsl
      assert_equal "hsla(145.00, 20.00%, 30.00%, 1.00)", @hsl.css_hsla
    end

    def test_to_cmyk
      cmyk = @hsl.to_cmyk
      assert_kind_of Colour::CMYK, cmyk
      assert_in_delta 0.3223, cmyk.c, Colour::COLOR_TOLERANCE
      assert_in_delta 0.2023, cmyk.m, Colour::COLOR_TOLERANCE
      assert_in_delta 0.2723, cmyk.y, Colour::COLOR_TOLERANCE
      assert_in_delta 0.4377, cmyk.k, Colour::COLOR_TOLERANCE
    end

    def test_to_grayscale
      gs = @hsl.to_grayscale
      assert_kind_of Colour::GreyScale, gs
      assert_in_delta 30, gs.gray, Colour::COLOR_TOLERANCE
    end

    def test_to_rgb
      rgb = @hsl.to_rgb
      assert_kind_of Colour::RGB, rgb
      assert_in_delta 0.24, rgb.r, Colour::COLOR_TOLERANCE
      assert_in_delta 0.36, rgb.g, Colour::COLOR_TOLERANCE
      assert_in_delta 0.29, rgb.b, Colour::COLOR_TOLERANCE
      assert_equal "#3d5c4a", @hsl.html
      assert_equal "rgb(24.00%, 36.00%, 29.00%)", @hsl.css_rgb
      assert_equal "rgba(24.00%, 36.00%, 29.00%, 1.00)", @hsl.css_rgba
      # The following tests address a bug reported by Jean Krohn on June 6,
      # 2006 and excercise some previously unexercised code in to_rgb.
      assert_equal Colour::RGB::Black, Colour::HSL.new(75, 75, 0)
      assert_equal Colour::RGB::White, Colour::HSL.new(75, 75, 100)
      assert_equal Colour::RGB::Gray80, Colour::HSL.new(75, 0, 80)

      # The following tests a bug reported by Adam Johnson on 29 October
      # 2010.
      rgb = Colour::RGB.from_fraction(0.34496, 0.1386, 0.701399)
      c = Colour::HSL.new(262, 67, 42).to_rgb
      assert_in_delta rgb.r, c.r, Colour::COLOR_TOLERANCE, "Red"
      assert_in_delta rgb.g, c.g, Colour::COLOR_TOLERANCE, "Green"
      assert_in_delta rgb.b, c.b, Colour::COLOR_TOLERANCE, "Blue"
    end

    def test_to_yiq
      yiq = @hsl.to_yiq
      assert_kind_of Colour::YIQ, yiq
      assert_in_delta 0.3161, yiq.y, Colour::COLOR_TOLERANCE
      assert_in_delta 0.0, yiq.i, Colour::COLOR_TOLERANCE
      assert_in_delta 0.0, yiq.q, Colour::COLOR_TOLERANCE
    end

    def test_mix_with
      red     = Colour::RGB::Red.to_hsl
      yellow  = Colour::RGB::Yellow.to_hsl
      assert_in_delta 0, red.hue, Colour::COLOR_TOLERANCE
      assert_in_delta 60, yellow.hue, Colour::COLOR_TOLERANCE
      ry25 = red.mix_with yellow, 0.25
      assert_in_delta 15, ry25.hue, Colour::COLOR_TOLERANCE
      ry50 = red.mix_with yellow, 0.50
      assert_in_delta 30, ry50.hue, Colour::COLOR_TOLERANCE
      ry75 = red.mix_with yellow, 0.75
      assert_in_delta 45, ry75.hue, Colour::COLOR_TOLERANCE
    end

    def test_inspect
      assert_equal "HSL [145.00 deg, 20.00%, 30.00%]", @hsl.inspect
    end
  end
end
