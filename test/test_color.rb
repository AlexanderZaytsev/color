# -*- ruby encoding: utf-8 -*-

require 'color'
require 'minitest_helper'

module TestColour
  class TestColour < Minitest::Test
    def setup
      Kernel.module_eval do
        alias old_warn warn

        def warn(message)
          $last_warn = message
        end
      end
    end

    def teardown
      Kernel.module_eval do
        undef warn
        alias warn old_warn
        undef old_warn
      end
    end

    def test_const
      $last_warn = nil
      assert_equal(Colour::RGB::AliceBlue, Colour::AliceBlue)
      assert_equal("Colour::AliceBlue has been deprecated. Use Colour::RGB::AliceBlue instead.", $last_warn)

      $last_warn = nil # Do this twice to make sure it always happens...
      assert(Colour::AliceBlue)
      assert_equal("Colour::AliceBlue has been deprecated. Use Colour::RGB::AliceBlue instead.", $last_warn)

      $last_warn = nil
      assert_equal(Colour::COLOR_VERSION, Colour::VERSION)
      assert_equal("Colour::VERSION has been deprecated. Use Colour::COLOR_VERSION instead.", $last_warn)

      $last_warn = nil
      assert_equal(Colour::COLOR_VERSION, Colour::COLOR_TOOLS_VERSION)
      assert_equal("Colour::COLOR_TOOLS_VERSION has been deprecated. Use Colour::COLOR_VERSION instead.", $last_warn)

      $last_warn = nil
      assert(Colour::COLOR_VERSION)
      assert_nil($last_warn)
      assert(Colour::COLOR_EPSILON)
      assert_nil($last_warn)

      assert_raises(NameError) { assert(Colour::MISSING_VALUE) }
    end

    def test_normalize
      (1..10).each do |i|
        assert_equal(0.0, Colour.normalize(-7 * i))
        assert_equal(0.0, Colour.normalize(-7 / i))
        assert_equal(0.0, Colour.normalize(0 - i))
        assert_equal(1.0, Colour.normalize(255 + i))
        assert_equal(1.0, Colour.normalize(256 * i))
        assert_equal(1.0, Colour.normalize(65536 / i))
      end
      (0..255).each do |i|
        assert_in_delta(i / 255.0, Colour.normalize(i / 255.0),
                        1e-2)
      end
    end

    def test_normalize_range
      assert_equal(0, Colour.normalize_8bit(-1))
      assert_equal(0, Colour.normalize_8bit(0))
      assert_equal(127, Colour.normalize_8bit(127))
      assert_equal(172, Colour.normalize_8bit(172))
      assert_equal(255, Colour.normalize_8bit(255))
      assert_equal(255, Colour.normalize_8bit(256))

      assert_equal(0, Colour.normalize_16bit(-1))
      assert_equal(0, Colour.normalize_16bit(0))
      assert_equal(127, Colour.normalize_16bit(127))
      assert_equal(172, Colour.normalize_16bit(172))
      assert_equal(255, Colour.normalize_16bit(255))
      assert_equal(256, Colour.normalize_16bit(256))
      assert_equal(65535, Colour.normalize_16bit(65535))
      assert_equal(65535, Colour.normalize_16bit(66536))

      assert_equal(-100, Colour.normalize_to_range(-101, -100..100))
      assert_equal(-100, Colour.normalize_to_range(-100.5, -100..100))
      assert_equal(-100, Colour.normalize_to_range(-100, -100..100))
      assert_equal(-100, Colour.normalize_to_range(-100.0, -100..100))
      assert_equal(-99.5, Colour.normalize_to_range(-99.5, -100..100))
      assert_equal(-50, Colour.normalize_to_range(-50, -100..100))
      assert_equal(-50.5, Colour.normalize_to_range(-50.5, -100..100))
      assert_equal(0, Colour.normalize_to_range(0, -100..100))
      assert_equal(50, Colour.normalize_to_range(50, -100..100))
      assert_equal(50.5, Colour.normalize_to_range(50.5, -100..100))
      assert_equal(99, Colour.normalize_to_range(99, -100..100))
      assert_equal(99.5, Colour.normalize_to_range(99.5, -100..100))
      assert_equal(100, Colour.normalize_to_range(100, -100..100))
      assert_equal(100, Colour.normalize_to_range(100.0, -100..100))
      assert_equal(100, Colour.normalize_to_range(100.5, -100..100))
      assert_equal(100, Colour.normalize_to_range(101, -100..100))
    end

    def test_new
      $last_warn = nil
      c = Colour.new("#fff")
      assert_kind_of(Colour::HSL, c)
      assert_equal(Colour::RGB::White.to_hsl, c)
      assert_equal("Colour.new has been deprecated. Use Colour::RGB.new instead.", $last_warn)

      $last_warn = nil
      c = Colour.new([0, 0, 0])
      assert_kind_of(Colour::HSL, c)
      assert_equal(Colour::RGB::Black.to_hsl, c)
      assert_equal("Colour.new has been deprecated. Use Colour::RGB.new instead.", $last_warn)

      $last_warn = nil
      c = Colour.new([10, 20, 30], :hsl)
      assert_kind_of(Colour::HSL, c)
      assert_equal(Colour::HSL.new(10, 20, 30), c)
      assert_equal("Colour.new has been deprecated. Use Colour::HSL.new instead.", $last_warn)

      $last_warn = nil
      c = Colour.new([10, 20, 30, 40], :cmyk)
      assert_kind_of(Colour::HSL, c)
      assert_equal(Colour::CMYK.new(10, 20, 30, 40).to_hsl, c)
      assert_equal("Colour.new has been deprecated. Use Colour::CMYK.new instead.", $last_warn)
    end
  end
end
