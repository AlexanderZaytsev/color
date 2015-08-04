# -*- ruby encoding: utf-8 -*-

require 'color'
require 'minitest_helper'

module TestColour
  class TestRGB < Minitest::Test
    def test_adjust_brightness
      assert_equal("#1a1aff", Colour::RGB::Blue.adjust_brightness(10).html)
      assert_equal("#0000e6", Colour::RGB::Blue.adjust_brightness(-10).html)
    end

    def test_adjust_hue
      assert_equal("#6600ff", Colour::RGB::Blue.adjust_hue(10).html)
      assert_equal("#0066ff", Colour::RGB::Blue.adjust_hue(-10).html)
    end

    def test_adjust_saturation
      assert_equal("#ef9374",
                   Colour::RGB::DarkSalmon.adjust_saturation(10).html)
      assert_equal("#e39980",
                   Colour::RGB::DarkSalmon.adjust_saturation(-10).html)
    end

    def test_red
      red = Colour::RGB::Red.dup
      assert_in_delta(1.0, red.r, Colour::COLOR_TOLERANCE)
      assert_in_delta(100, red.red_p, Colour::COLOR_TOLERANCE)
      assert_in_delta(255, red.red, Colour::COLOR_TOLERANCE)
      assert_in_delta(1.0, red.r, Colour::COLOR_TOLERANCE)
      red.red_p = 33
      assert_in_delta(0.33, red.r, Colour::COLOR_TOLERANCE)
      red.red = 330
      assert_in_delta(1.0, red.r, Colour::COLOR_TOLERANCE)
      red.r = -3.3
      assert_in_delta(0.0, red.r, Colour::COLOR_TOLERANCE)
    end

    def test_green
      lime = Colour::RGB::Lime.dup
      assert_in_delta(1.0, lime.g, Colour::COLOR_TOLERANCE)
      assert_in_delta(100, lime.green_p, Colour::COLOR_TOLERANCE)
      assert_in_delta(255, lime.green, Colour::COLOR_TOLERANCE)
      lime.green_p = 33
      assert_in_delta(0.33, lime.g, Colour::COLOR_TOLERANCE)
      lime.green = 330
      assert_in_delta(1.0, lime.g, Colour::COLOR_TOLERANCE)
      lime.g = -3.3
      assert_in_delta(0.0, lime.g, Colour::COLOR_TOLERANCE)
    end

    def test_blue
      blue = Colour::RGB::Blue.dup
      assert_in_delta(1.0, blue.b, Colour::COLOR_TOLERANCE)
      assert_in_delta(255, blue.blue, Colour::COLOR_TOLERANCE)
      assert_in_delta(100, blue.blue_p, Colour::COLOR_TOLERANCE)
      blue.blue_p = 33
      assert_in_delta(0.33, blue.b, Colour::COLOR_TOLERANCE)
      blue.blue = 330
      assert_in_delta(1.0, blue.b, Colour::COLOR_TOLERANCE)
      blue.b = -3.3
      assert_in_delta(0.0, blue.b, Colour::COLOR_TOLERANCE)
    end

    def test_brightness
      assert_in_delta(0.0, Colour::RGB::Black.brightness, Colour::COLOR_TOLERANCE)
      assert_in_delta(0.5, Colour::RGB::Grey50.brightness, Colour::COLOR_TOLERANCE)
      assert_in_delta(1.0, Colour::RGB::White.brightness, Colour::COLOR_TOLERANCE)
    end

    def test_darken_by
      assert_in_delta(0.5, Colour::RGB::Blue.darken_by(50).b,
                      Colour::COLOR_TOLERANCE)
    end

    def test_html
      assert_equal("#000000", Colour::RGB::Black.html)
      assert_equal(Colour::RGB::Black, Colour::RGB.from_html("#000000"))
      assert_equal("#0000ff", Colour::RGB::Blue.html)
      assert_equal("#00ff00", Colour::RGB::Lime.html)
      assert_equal("#ff0000", Colour::RGB::Red.html)
      assert_equal("#ffffff", Colour::RGB::White.html)

      assert_equal("rgb(0.00%, 0.00%, 0.00%)", Colour::RGB::Black.css_rgb)
      assert_equal("rgb(0.00%, 0.00%, 100.00%)", Colour::RGB::Blue.css_rgb)
      assert_equal("rgb(0.00%, 100.00%, 0.00%)", Colour::RGB::Lime.css_rgb)
      assert_equal("rgb(100.00%, 0.00%, 0.00%)", Colour::RGB::Red.css_rgb)
      assert_equal("rgb(100.00%, 100.00%, 100.00%)", Colour::RGB::White.css_rgb)

      assert_equal("rgba(0.00%, 0.00%, 0.00%, 1.00)", Colour::RGB::Black.css_rgba)
      assert_equal("rgba(0.00%, 0.00%, 100.00%, 1.00)", Colour::RGB::Blue.css_rgba)
      assert_equal("rgba(0.00%, 100.00%, 0.00%, 1.00)", Colour::RGB::Lime.css_rgba)
      assert_equal("rgba(100.00%, 0.00%, 0.00%, 1.00)", Colour::RGB::Red.css_rgba)
      assert_equal("rgba(100.00%, 100.00%, 100.00%, 1.00)",
                   Colour::RGB::White.css_rgba)
    end

    def test_lighten_by
      assert_in_delta(1.0, Colour::RGB::Blue.lighten_by(50).b,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.5, Colour::RGB::Blue.lighten_by(50).r,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.5, Colour::RGB::Blue.lighten_by(50).g,
                      Colour::COLOR_TOLERANCE)
    end

    def test_mix_with
      assert_in_delta(0.5, Colour::RGB::Red.mix_with(Colour::RGB::Blue, 50).r,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.0, Colour::RGB::Red.mix_with(Colour::RGB::Blue, 50).g,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.5, Colour::RGB::Red.mix_with(Colour::RGB::Blue, 50).b,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.5, Colour::RGB::Blue.mix_with(Colour::RGB::Red, 50).r,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.0, Colour::RGB::Blue.mix_with(Colour::RGB::Red, 50).g,
                      Colour::COLOR_TOLERANCE)
      assert_in_delta(0.5, Colour::RGB::Blue.mix_with(Colour::RGB::Red, 50).b,
                      Colour::COLOR_TOLERANCE)
    end

    def test_pdf_fill
      assert_equal("0.000 0.000 0.000 rg", Colour::RGB::Black.pdf_fill)
      assert_equal("0.000 0.000 1.000 rg", Colour::RGB::Blue.pdf_fill)
      assert_equal("0.000 1.000 0.000 rg", Colour::RGB::Lime.pdf_fill)
      assert_equal("1.000 0.000 0.000 rg", Colour::RGB::Red.pdf_fill)
      assert_equal("1.000 1.000 1.000 rg", Colour::RGB::White.pdf_fill)
      assert_equal("0.000 0.000 0.000 RG", Colour::RGB::Black.pdf_stroke)
      assert_equal("0.000 0.000 1.000 RG", Colour::RGB::Blue.pdf_stroke)
      assert_equal("0.000 1.000 0.000 RG", Colour::RGB::Lime.pdf_stroke)
      assert_equal("1.000 0.000 0.000 RG", Colour::RGB::Red.pdf_stroke)
      assert_equal("1.000 1.000 1.000 RG", Colour::RGB::White.pdf_stroke)
    end

    def test_to_cmyk
      assert_kind_of(Colour::CMYK, Colour::RGB::Black.to_cmyk)
      assert_equal(Colour::CMYK.new(0, 0, 0, 100), Colour::RGB::Black.to_cmyk)
      assert_equal(Colour::CMYK.new(0, 0, 100, 0),
                   Colour::RGB::Yellow.to_cmyk)
      assert_equal(Colour::CMYK.new(100, 0, 0, 0), Colour::RGB::Cyan.to_cmyk)
      assert_equal(Colour::CMYK.new(0, 100, 0, 0),
                   Colour::RGB::Magenta.to_cmyk)
      assert_equal(Colour::CMYK.new(0, 100, 100, 0), Colour::RGB::Red.to_cmyk)
      assert_equal(Colour::CMYK.new(100, 0, 100, 0),
                   Colour::RGB::Lime.to_cmyk)
      assert_equal(Colour::CMYK.new(100, 100, 0, 0),
                   Colour::RGB::Blue.to_cmyk)
      assert_equal(Colour::CMYK.new(10.32, 60.52, 10.32, 39.47),
                   Colour::RGB::Purple.to_cmyk)
      assert_equal(Colour::CMYK.new(10.90, 59.13, 59.13, 24.39),
                   Colour::RGB::Brown.to_cmyk)
      assert_equal(Colour::CMYK.new(0, 63.14, 18.43, 0),
                   Colour::RGB::Carnation.to_cmyk)
      assert_equal(Colour::CMYK.new(7.39, 62.69, 62.69, 37.32),
                   Colour::RGB::Cayenne.to_cmyk)
    end

    def test_to_grayscale
      assert_kind_of(Colour::GrayScale, Colour::RGB::Black.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0),
                   Colour::RGB::Black.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.5),
                   Colour::RGB::Yellow.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.5),
                   Colour::RGB::Cyan.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.5),
                   Colour::RGB::Magenta.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.5),
                   Colour::RGB::Red.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.5),
                   Colour::RGB::Lime.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.5),
                   Colour::RGB::Blue.to_grayscale)
      assert_equal(Colour::GrayScale.from_fraction(0.2510),
                   Colour::RGB::Purple.to_grayscale)
      assert_equal(Colour::GrayScale.new(40.58),
                   Colour::RGB::Brown.to_grayscale)
      assert_equal(Colour::GrayScale.new(68.43),
                   Colour::RGB::Carnation.to_grayscale)
      assert_equal(Colour::GrayScale.new(27.65),
                   Colour::RGB::Cayenne.to_grayscale)
    end

    def test_to_hsl
      assert_kind_of(Colour::HSL, Colour::RGB::Black.to_hsl)
      assert_equal(Colour::HSL.new, Colour::RGB::Black.to_hsl)
      assert_equal(Colour::HSL.new(60, 100, 50), Colour::RGB::Yellow.to_hsl)
      assert_equal(Colour::HSL.new(180, 100, 50), Colour::RGB::Cyan.to_hsl)
      assert_equal(Colour::HSL.new(300, 100, 50), Colour::RGB::Magenta.to_hsl)
      assert_equal(Colour::HSL.new(0, 100, 50), Colour::RGB::Red.to_hsl)
      assert_equal(Colour::HSL.new(120, 100, 50), Colour::RGB::Lime.to_hsl)
      assert_equal(Colour::HSL.new(240, 100, 50), Colour::RGB::Blue.to_hsl)
      assert_equal(Colour::HSL.new(300, 100, 25.10),
                   Colour::RGB::Purple.to_hsl)
      assert_equal(Colour::HSL.new(0, 59.42, 40.59),
                   Colour::RGB::Brown.to_hsl)
      assert_equal(Colour::HSL.new(317.5, 100, 68.43),
                   Colour::RGB::Carnation.to_hsl)
      assert_equal(Colour::HSL.new(0, 100, 27.64),
                   Colour::RGB::Cayenne.to_hsl)

      assert_equal("hsl(0.00, 0.00%, 0.00%)", Colour::RGB::Black.css_hsl)
      assert_equal("hsl(60.00, 100.00%, 50.00%)",
                   Colour::RGB::Yellow.css_hsl)
      assert_equal("hsl(180.00, 100.00%, 50.00%)", Colour::RGB::Cyan.css_hsl)
      assert_equal("hsl(300.00, 100.00%, 50.00%)",
                   Colour::RGB::Magenta.css_hsl)
      assert_equal("hsl(0.00, 100.00%, 50.00%)", Colour::RGB::Red.css_hsl)
      assert_equal("hsl(120.00, 100.00%, 50.00%)", Colour::RGB::Lime.css_hsl)
      assert_equal("hsl(240.00, 100.00%, 50.00%)", Colour::RGB::Blue.css_hsl)
      assert_equal("hsl(300.00, 100.00%, 25.10%)",
                   Colour::RGB::Purple.css_hsl)
      assert_equal("hsl(0.00, 59.42%, 40.59%)", Colour::RGB::Brown.css_hsl)
      assert_equal("hsl(317.52, 100.00%, 68.43%)",
                   Colour::RGB::Carnation.css_hsl)
      assert_equal("hsl(0.00, 100.00%, 27.65%)", Colour::RGB::Cayenne.css_hsl)

      assert_equal("hsla(0.00, 0.00%, 0.00%, 1.00)",
                   Colour::RGB::Black.css_hsla)
      assert_equal("hsla(60.00, 100.00%, 50.00%, 1.00)",
                   Colour::RGB::Yellow.css_hsla)
      assert_equal("hsla(180.00, 100.00%, 50.00%, 1.00)",
                   Colour::RGB::Cyan.css_hsla)
      assert_equal("hsla(300.00, 100.00%, 50.00%, 1.00)",
                   Colour::RGB::Magenta.css_hsla)
      assert_equal("hsla(0.00, 100.00%, 50.00%, 1.00)",
                   Colour::RGB::Red.css_hsla)
      assert_equal("hsla(120.00, 100.00%, 50.00%, 1.00)",
                   Colour::RGB::Lime.css_hsla)
      assert_equal("hsla(240.00, 100.00%, 50.00%, 1.00)",
                   Colour::RGB::Blue.css_hsla)
      assert_equal("hsla(300.00, 100.00%, 25.10%, 1.00)",
                   Colour::RGB::Purple.css_hsla)
      assert_equal("hsla(0.00, 59.42%, 40.59%, 1.00)",
                   Colour::RGB::Brown.css_hsla)
      assert_equal("hsla(317.52, 100.00%, 68.43%, 1.00)",
                   Colour::RGB::Carnation.css_hsla)
      assert_equal("hsla(0.00, 100.00%, 27.65%, 1.00)",
                   Colour::RGB::Cayenne.css_hsla)

      # The following tests a bug reported by Jean Krohn on 10 June 2006
      # where HSL conversion was not quite correct, resulting in a bad
      # round-trip.
      assert_equal("#008800", Colour::RGB.from_html("#008800").to_hsl.html)
      refute_equal("#002288", Colour::RGB.from_html("#008800").to_hsl.html)

      # The following tests a bug reported by Adam Johnson on 29 October
      # 2010.
      hsl = Colour::HSL.new(262, 67, 42)
      c = Colour::RGB.from_fraction(0.34496, 0.1386, 0.701399).to_hsl
      assert_in_delta hsl.h, c.h, Colour::COLOR_TOLERANCE, "Hue"
      assert_in_delta hsl.s, c.s, Colour::COLOR_TOLERANCE, "Saturation"
      assert_in_delta hsl.l, c.l, Colour::COLOR_TOLERANCE, "Luminance"
    end

    def test_to_rgb
      assert_same(Colour::RGB::Black, Colour::RGB::Black.to_rgb)
    end

    def test_to_yiq
      assert_kind_of(Colour::YIQ, Colour::RGB::Black.to_yiq)
      assert_equal(Colour::YIQ.new, Colour::RGB::Black.to_yiq)
      assert_equal(Colour::YIQ.new(88.6, 32.1, 0), Colour::RGB::Yellow.to_yiq)
      assert_equal(Colour::YIQ.new(70.1, 0, 0), Colour::RGB::Cyan.to_yiq)
      assert_equal(Colour::YIQ.new(41.3, 27.5, 52.3),
                   Colour::RGB::Magenta.to_yiq)
      assert_equal(Colour::YIQ.new(29.9, 59.6, 21.2), Colour::RGB::Red.to_yiq)
      assert_equal(Colour::YIQ.new(58.7, 0, 0), Colour::RGB::Lime.to_yiq)
      assert_equal(Colour::YIQ.new(11.4, 0, 31.1), Colour::RGB::Blue.to_yiq)
      assert_equal(Colour::YIQ.new(20.73, 13.80, 26.25),
                   Colour::RGB::Purple.to_yiq)
      assert_equal(Colour::YIQ.new(30.89, 28.75, 10.23),
                   Colour::RGB::Brown.to_yiq)
      assert_equal(Colour::YIQ.new(60.84, 23.28, 27.29),
                   Colour::RGB::Carnation.to_yiq)
      assert_equal(Colour::YIQ.new(16.53, 32.96, 11.72),
                   Colour::RGB::Cayenne.to_yiq)
    end

    def test_to_lab
      # Luminosity can be an absolute.
      assert_in_delta(0.0, Colour::RGB::Black.to_lab[:L], Colour::COLOR_TOLERANCE)
      assert_in_delta(100.0, Colour::RGB::White.to_lab[:L], Colour::COLOR_TOLERANCE)

      # It's not really possible to have absolute
      # numbers here because of how L*a*b* works, but
      # negative/positive comparisons work
      assert(Colour::RGB::Green.to_lab[:a] < 0)
      assert(Colour::RGB::Magenta.to_lab[:a] > 0)
      assert(Colour::RGB::Blue.to_lab[:b] < 0)
      assert(Colour::RGB::Yellow.to_lab[:b] > 0)
    end

    def test_closest_match
      # It should match Blue to Indigo (very simple match)
      match_from = [Colour::RGB::Red, Colour::RGB::Green, Colour::RGB::Blue]
      assert_equal(Colour::RGB::Blue, Colour::RGB::Indigo.closest_match(match_from))
      # But fails if using the :just_noticeable difference.
      assert_nil(Colour::RGB::Indigo.closest_match(match_from, :just_noticeable))

      # Crimson & Firebrick are visually closer than DarkRed and Firebrick
      # (more precise match)
      match_from += [Colour::RGB::DarkRed, Colour::RGB::Crimson]
      assert_equal(Colour::RGB::Crimson,
                   Colour::RGB::Firebrick.closest_match(match_from))
      # Specifying a threshold low enough will cause even that match to
      # fail, though.
      assert_nil(Colour::RGB::Firebrick.closest_match(match_from, 8.0))
      # If the match_from list is an empty array, it also returns nil
      assert_nil(Colour::RGB::Red.closest_match([]))

      # RGB::Green is 0,128,0, so we'll pick something VERY close to it, visually
      jnd_green = Colour::RGB.new(3, 132, 3)
      assert_equal(Colour::RGB::Green,
                   jnd_green.closest_match(match_from, :jnd))
      # And then something that's just barely out of the tolerance range
      diff_green = Colour::RGB.new(9, 142, 9)
      assert_nil(diff_green.closest_match(match_from, :jnd))
    end

    def test_add
      white = Colour::RGB::Cyan + Colour::RGB::Yellow
      refute_nil(white)
      assert_equal(Colour::RGB::White, white)

      c1 = Colour::RGB.new(0x80, 0x80, 0x00)
      c2 = Colour::RGB.new(0x45, 0x20, 0xf0)
      cr = Colour::RGB.new(0xc5, 0xa0, 0xf0)

      assert_equal(cr, c1 + c2)
    end

    def test_subtract
      black = Colour::RGB::LightCoral - Colour::RGB::Honeydew
      assert_equal(Colour::RGB::Black, black)

      c1 = Colour::RGB.new(0x85, 0x80, 0x00)
      c2 = Colour::RGB.new(0x40, 0x20, 0xf0)
      cr = Colour::RGB.new(0x45, 0x60, 0x00)

      assert_equal(cr, c1 - c2)
    end

    def test_mean_grayscale
      c1        = Colour::RGB.new(0x85, 0x80, 0x00)
      c1_max    = c1.max_rgb_as_greyscale
      c1_max    = c1.max_rgb_as_greyscale
      c1_result = Colour::GrayScale.from_fraction(0x85 / 255.0)

      assert_equal(c1_result, c1_max)
    end

    def test_from_html
      assert_equal("RGB [#333333]", Colour::RGB.from_html("#333").inspect)
      assert_equal("RGB [#333333]", Colour::RGB.from_html("333").inspect)
      assert_equal("RGB [#555555]", Colour::RGB.from_html("#555555").inspect)
      assert_equal("RGB [#555555]", Colour::RGB.from_html("555555").inspect)
      assert_raises(ArgumentError) { Colour::RGB.from_html("#5555555") }
      assert_raises(ArgumentError) { Colour::RGB.from_html("5555555") }
      assert_raises(ArgumentError) { Colour::RGB.from_html("#55555") }
      assert_raises(ArgumentError) { Colour::RGB.from_html("55555") }
    end

    def test_by_hex
      assert_same(Colour::RGB::Cyan, Colour::RGB.by_hex('#0ff'))
      assert_same(Colour::RGB::Cyan, Colour::RGB.by_hex('#00ffff'))
      assert_equal("RGB [#333333]", Colour::RGB.by_hex("#333").inspect)
      assert_equal("RGB [#333333]", Colour::RGB.by_hex("333").inspect)
      assert_raises(ArgumentError) { Colour::RGB.by_hex("5555555") }
      assert_raises(ArgumentError) { Colour::RGB.by_hex("#55555") }
      assert_equal(:boom, Colour::RGB.by_hex('#55555') { :boom })
    end

    def test_by_name
      assert_same(Colour::RGB::Cyan, Colour::RGB.by_name('cyan'))

      fetch_error = if RUBY_VERSION < "1.9"
                      IndexError
                    else
                      KeyError
                    end

      assert_raises(fetch_error) { Colour::RGB.by_name('cyanide') }
      assert_equal(:boom, Colour::RGB.by_name('cyanide') { :boom })
    end

    def test_by_css
      assert_same(Colour::RGB::Cyan, Colour::RGB.by_css('#0ff'))
      assert_same(Colour::RGB::Cyan, Colour::RGB.by_css('cyan'))
      assert_raises(ArgumentError) { Colour::RGB.by_css('cyanide') }
      assert_equal(:boom, Colour::RGB.by_css('cyanide') { :boom })
    end

    def test_extract_colors
      assert_equal([ Colour::RGB::BlanchedAlmond, Colour::RGB::Cyan ],
                   Colour::RGB.extract_colors('BlanchedAlmond is a nice shade, but #00ffff is not.'))
    end

    def test_inspect
      assert_equal("RGB [#000000]", Colour::RGB::Black.inspect)
      assert_equal("RGB [#0000ff]", Colour::RGB::Blue.inspect)
      assert_equal("RGB [#00ff00]", Colour::RGB::Lime.inspect)
      assert_equal("RGB [#ff0000]", Colour::RGB::Red.inspect)
      assert_equal("RGB [#ffffff]", Colour::RGB::White.inspect)
    end
  end
end
