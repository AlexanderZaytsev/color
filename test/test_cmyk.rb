# -*- ruby encoding: utf-8 -*-

require 'color'
require 'minitest_helper'

module TestColour
  class TestCMYK < Minitest::Test
    def setup
      @cmyk = Colour::CMYK.new(10, 20, 30, 40)
    end

    def test_cyan
      assert_in_delta(0.1, @cmyk.c, Colour::COLOR_TOLERANCE)
      assert_in_delta(10, @cmyk.cyan, Colour::COLOR_TOLERANCE)
      @cmyk.cyan = 20
      assert_in_delta(0.2, @cmyk.c, Colour::COLOR_TOLERANCE)
      @cmyk.c = 2.0
      assert_in_delta(100, @cmyk.cyan, Colour::COLOR_TOLERANCE)
      @cmyk.c = -1.0
      assert_in_delta(0.0, @cmyk.c, Colour::COLOR_TOLERANCE)
    end

    def test_magenta
      assert_in_delta(0.2, @cmyk.m, Colour::COLOR_TOLERANCE)
      assert_in_delta(20, @cmyk.magenta, Colour::COLOR_TOLERANCE)
      @cmyk.magenta = 30
      assert_in_delta(0.3, @cmyk.m, Colour::COLOR_TOLERANCE)
      @cmyk.m = 2.0
      assert_in_delta(100, @cmyk.magenta, Colour::COLOR_TOLERANCE)
      @cmyk.m = -1.0
      assert_in_delta(0.0, @cmyk.m, Colour::COLOR_TOLERANCE)
    end

    def test_yellow
      assert_in_delta(0.3, @cmyk.y, Colour::COLOR_TOLERANCE)
      assert_in_delta(30, @cmyk.yellow, Colour::COLOR_TOLERANCE)
      @cmyk.yellow = 20
      assert_in_delta(0.2, @cmyk.y, Colour::COLOR_TOLERANCE)
      @cmyk.y = 2.0
      assert_in_delta(100, @cmyk.yellow, Colour::COLOR_TOLERANCE)
      @cmyk.y = -1.0
      assert_in_delta(0.0, @cmyk.y, Colour::COLOR_TOLERANCE)
    end

    def test_black
      assert_in_delta(0.4, @cmyk.k, Colour::COLOR_TOLERANCE)
      assert_in_delta(40, @cmyk.black, Colour::COLOR_TOLERANCE)
      @cmyk.black = 20
      assert_in_delta(0.2, @cmyk.k, Colour::COLOR_TOLERANCE)
      @cmyk.k = 2.0
      assert_in_delta(100, @cmyk.black, Colour::COLOR_TOLERANCE)
      @cmyk.k = -1.0
      assert_in_delta(0.0, @cmyk.k, Colour::COLOR_TOLERANCE)
    end

    def test_pdf
      assert_equal("0.100 0.200 0.300 0.400 k", @cmyk.pdf_fill)
      assert_equal("0.100 0.200 0.300 0.400 K", @cmyk.pdf_stroke)
    end

    def test_to_cmyk
      assert(@cmyk.to_cmyk == @cmyk)
    end

    def test_to_grayscale
      gs = @cmyk.to_grayscale
      assert_kind_of(Colour::GrayScale, gs)
      assert_in_delta(0.4185, gs.g, Colour::COLOR_TOLERANCE)
      assert_kind_of(Colour::GreyScale, @cmyk.to_greyscale)
    end

    def test_to_hsl
      hsl = @cmyk.to_hsl
      assert_kind_of(Colour::HSL, hsl)
      assert_in_delta(0.48, hsl.l, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.125, hsl.s, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.08333, hsl.h, Colour::COLOR_TOLERANCE)
      assert_equal("hsl(30.00, 12.50%, 48.00%)", @cmyk.css_hsl)
      assert_equal("hsla(30.00, 12.50%, 48.00%, 1.00)", @cmyk.css_hsla)
    end

    def test_to_rgb
      rgb = @cmyk.to_rgb(true)
      assert_kind_of(Colour::RGB, rgb)
      assert_in_delta(0.5, rgb.r, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.4, rgb.g, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.3, rgb.b, Colour::COLOR_TOLERANCE)

      rgb = @cmyk.to_rgb
      assert_kind_of(Colour::RGB, rgb)
      assert_in_delta(0.54, rgb.r, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.48, rgb.g, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.42, rgb.b, Colour::COLOR_TOLERANCE)

      assert_equal("#8a7a6b", @cmyk.html)
      assert_equal("rgb(54.00%, 48.00%, 42.00%)", @cmyk.css_rgb)
      assert_equal("rgba(54.00%, 48.00%, 42.00%, 1.00)", @cmyk.css_rgba)
    end

    def test_inspect
      assert_equal("CMYK [10.00%, 20.00%, 30.00%, 40.00%]", @cmyk.inspect)
    end

    def test_to_yiq
      yiq = @cmyk.to_yiq
      assert_kind_of(Colour::YIQ, yiq)
      assert_in_delta(0.4911, yiq.y, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.05502, yiq.i, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.0, yiq.q, Colour::COLOR_TOLERANCE)
    end
  end
end
