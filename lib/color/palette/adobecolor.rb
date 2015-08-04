require 'color/palette'

# A class that can read an Adobe Colour palette file (used for Photoshop
# swatches) and provide a Hash-like interface to the contents. Not all
# colour formats in ACO files are supported. Based largely off the
# information found by Larry Tesler[http://www.nomodes.com/aco.html].
#
# Not all Adobe Colour files have named colours; all named entries are
# returned as an array.
#
#   pal = Colour::Palette::AdobeColour.from_file(my_aco_palette)
#   pal[0]          => Colour::RGB<...>
#   pal["white"]    => [ Colour::RGB<...> ]
#   pal["unknown"]  => [ Colour::RGB<...>, Colour::RGB<...>, ... ]
#
# AdobeColour palettes are always indexable by insertion order (an integer
# key).
#
# Version 2 palettes use UTF-16 colour names.
class Colour::Palette::AdobeColour
  include Enumerable

  class << self
    # Create an AdobeColour palette object from the named file.
    def from_file(filename)
      File.open(filename, "rb") { |io| Colour::Palette::AdobeColour.from_io(io) }
    end

    # Create an AdobeColour palette object from the provided IO.
    def from_io(io)
      Colour::Palette::AdobeColour.new(io.read)
    end
  end

  # Returns statistics about the nature of the colours loaded.
  attr_reader :statistics
  # Contains the "lost" colours in the palette. These colours could not be
  # properly loaded (e.g., L*a*b* is not supported by Colour, so it is
  # "lost") or are not understood by the algorithms.
  attr_reader :lost

  # Use this to convert the unsigned word to the signed word, if necessary.
  UwToSw = proc { |n| (n >= (2 ** 16)) ? n - (2 ** 32) : n } #:nodoc:

  # Create a new AdobeColour palette from the palette file as a string.
  def initialize(palette)
    @colors     = []
    @names      = {}
    @statistics = Hash.new(0)
    @lost       = []
    @order      = []
    @version    = nil

    class << palette
      def readwords(count = 1)
        @offset ||= 0
        raise IndexError if @offset >= self.size
        val = self[@offset, count * 2]
        raise IndexError if val.nil? or val.size < (count * 2)
        val = val.unpack("n" * count)
        @offset += count * 2
        val
      end

      def readutf16(count = 1)
        @offset ||= 0
        raise IndexError if @offset >= self.size
        val = self[@offset, count * 2]
        raise IndexError if val.nil? or val.size < (count * 2)
        @offset += count * 2
        val
      end
    end

    @version, count = palette.readwords 2

    raise "Unknown AdobeColour palette version #@version." unless @version.between?(1, 2)

    count.times do
      space, w, x, y, z = palette.readwords 5
      name = nil
      if @version == 2
        raise IndexError unless palette.readwords == [ 0 ]
        len = palette.readwords
        name = palette.readutf16(len[0] - 1)
        raise IndexError unless palette.readwords == [ 0 ]
      end

      color = case space
              when 0 then # RGB
                @statistics[:rgb] += 1

                Colour::RGB.new(w / 256, x / 256, y / 256)
              when 1 then # HS[BV] -- Convert to RGB
                @statistics[:hsb] += 1

                h = w / 65535.0
                s = x / 65535.0
                v = y / 65535.0

                if defined?(Colour::HSB)
                  Colour::HSB.from_fraction(h, s, v)
                else
                  @statistics[:converted] += 1
                  if Colour.near_zero_or_less?(s)
                    Colour::RGB.from_fraction(v, v, v)
                  else
                    if Colour.near_one_or_more?(h)
                      vh = 0
                    else
                      vh = h * 6.0
                    end

                    vi = vh.floor
                    v1 = v.to_f * (1 - s.to_f)
                    v2 = v.to_f * (1 - s.to_f * (vh - vi))
                    v3 = v.to_f * (1 - s.to_f * (1 - (vh - vi)))

                    case vi
                    when 0 then Colour::RGB.from_fraction(v, v3, v1)
                    when 1 then Colour::RGB.from_fraction(v2, v, v1)
                    when 2 then Colour::RGB.from_fraction(v1, v, v3)
                    when 3 then Colour::RGB.from_fraction(v1, v2, v)
                    when 4 then Colour::RGB.from_fraction(v3, v1, v)
                    else Colour::RGB.from_fraction(v, v1, v2)
                    end
                  end
                end
              when 2 then # CMYK
                @statistics[:cmyk] += 1
                Colour::CMYK.from_percent(100 - (w / 655.35),
                                         100 - (x / 655.35),
                                         100 - (y / 655.35),
                                         100 - (z / 655.35))
              when 7 then # L*a*b*
                @statistics[:lab] += 1

                l = [w, 10000].min / 100.0
                a = [[-12800, UwToSw[x]].max, 12700].min / 100.0
                b = [[-12800, UwToSw[x]].max, 12700].min / 100.0

                if defined? Colour::Lab
                  Colour::Lab.new(l, a, b)
                else
                  [ space, w, x, y, z ]
                end
              when 8 then # Grayscale
                @statistics[:gray] += 1

                g = [w, 10000].min / 100.0
                Colour::GrayScale.new(g)
              when 9 then # Wide CMYK
                @statistics[:wcmyk] += 1

                c = [w, 10000].min / 100.0
                m = [x, 10000].min / 100.0
                y = [y, 10000].min / 100.0
                k = [z, 10000].min / 100.0
                Colour::CMYK.from_percent(c, m, y, k)
              else
                @statistics[space] += 1
                [ space, w, x, y, z ]
              end

      @order << [ color, name ]

      if color.kind_of? Array
        @lost << color
      else
        @colors << color

        if name
          @names[name] ||= []
          @names[name] << color
        end
      end
    end
  end

  # Provides the colour or colours at the provided selectors.
  def values_at(*selectors)
    @colors.values_at(*selectors)
  end

  # If a Numeric +key+ is provided, the single colour value at that position
  # will be returned. If a String +key+ is provided, the colour set (an
  # array) for that colour name will be returned.
  def [](key)
    if key.kind_of?(Numeric)
      @colors[key]
    else
      @names[key]
    end
  end

  # Loops through each colour.
  def each
    @colors.each { |el| yield el }
  end

  # Loops through each named colour set.
  def each_name #:yields color_name, color_set:#
    @names.each { |color_name, color_set| yield color_name, color_set }
  end

  def size
    @colors.size
  end

  attr_reader :version

  def to_aco(version = @version) #:nodoc:
    res = ""

    res << [ version, @order.size ].pack("nn")

    @order.each do |cnpair|
      color, name = *cnpair

      # Note: HSB and CMYK formats are lost by the conversions performed on
      # import. They are turned into RGB and WCMYK, respectively.

      cstr = case color
             when Array
               color
             when Colour::RGB
               r = [(color.red * 256).round, 65535].min
               g = [(color.green * 256).round, 65535].min
               b = [(color.blue * 256).round, 65535].min
               [ 0, r, g, b, 0 ]
             when Colour::GrayScale
               g = [(color.gray * 100).round, 10000].min
               [ 8, g, 0, 0, 0 ]
             when Colour::CMYK
               c = [(color.cyan * 100).round, 10000].min
               m = [(color.magenta * 100).round, 10000].min
               y = [(color.yellow * 100).round, 10000].min
               k = [(color.black * 100).round, 10000].min
               [ 9, c, m, y, k ]
             end
      cstr = cstr.pack("nnnnn")

      nstr = ""

      if version == 2
        if (name.size / 2 * 2) == name.size # only where s[0] == byte!
          nstr << [ 0, (name.size / 2) + 1 ].pack("nn")
          nstr << name
          nstr << [ 0 ].pack("n")
        else
          nstr << [ 0, 1, 0 ].pack("nnn")
        end
      end

      res << cstr << nstr
    end

    res
  end
end
