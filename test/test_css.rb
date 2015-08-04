require 'color'
require 'color/css'
require 'minitest_helper'

module TestColour
  class TestCSS < Minitest::Test
    def test_index_with_known_name
      assert_same(Colour::RGB::AliceBlue, Colour::CSS[:aliceblue])
      assert_same(Colour::RGB::AliceBlue, Colour::CSS["AliceBlue"])
      assert_same(Colour::RGB::AliceBlue, Colour::CSS["aliceBlue"])
      assert_same(Colour::RGB::AliceBlue, Colour::CSS["aliceblue"])
      assert_same(Colour::RGB::AliceBlue, Colour::CSS[:AliceBlue])
    end

    def test_index_with_unknown_name
      assert_equal(nil, Colour::CSS['redx'])
    end
  end
end
