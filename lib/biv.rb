require 'biv/version'
require 'RMagick'
require 'rainbow/ext/string'

# Implements a blocky image viewer
module Biv
  # An image to be printed in a blockily
  class Image
    # Load a new image for viewing
    def initialize(file, width: nil, height: nil, true_color: false, hd: true, bg: [0xFF, 0xFF, 0xFF])
      fail ArgumentError, 'Missing image width' if width.nil?

      begin
        @original_image = Magick::Image.read(file).first
      rescue
        raise ArgumentError, "I don't know how to open '#{file}'"
      end
      @width = width
      @height = height
      @true_color = true_color
      @hd = hd
      @bg = bg

      @height *= 2 if !@height.nil? && @hd
      preprocess

      fail ArgumentError, 'I failed to load the image' if @image.nil?
    end

    # Convert an image to an array of printable strings
    def to_a
      buffer = []

      for_row_indexes.each do |y|
        line = ''
        0.upto(@image.columns - 1).each do |x|
          p = get_pixel(x, y)
          block = make_block p
          line << block
        end
        line << "\x1b[0m" # Reset the color at the end of the line
        buffer << line
      end

      buffer
    end

    # Convert an image to a string
    def to_s
      to_a.join "\n"
    end

    private

    # Get the image ready to display
    def preprocess
      @image = @original_image
      @image.scale! @image.columns, @image.rows / 2 unless @hd

      if @height.nil?
        @image = @image.resize_to_fit(@width)
      else
        @height /= 2 unless @hd
        @image = @image.resize_to_fit(@width, @height)
      end
    end

    # Get a pixel at a coordinate
    def get_pixel(x, y)
      if @hd
        get_pixel_hd(x, y)
      else
        get_pixel_at(x, y)
      end
    end

    # Get two pixels from an HD coordinate
    def get_pixel_hd(x, y)
      p0 = get_pixel_at(x, y * 2)
      p1 = get_pixel_at(x, y * 2 + 1)

      [p0, p1]
    end

    # Get a pixel at a specific coordinate
    def get_pixel_at(x, y)
      begin
        p = get_rgb(@image.get_pixels(x, y, 1, 1).first)
      rescue RangeError
        p = @bg
      end
      p
    end

    # From a pixel get the rgb channels, taking into account transparency
    def get_rgb(p)
      r = p.red
      g = p.green
      b = p.blue
      a = p.opacity

      if a > 0
        r *= (Magick::QuantumRange - a) / Magick::QuantumRange
        g *= (Magick::QuantumRange - a) / Magick::QuantumRange
        b *= (Magick::QuantumRange - a) / Magick::QuantumRange
      end

      [r, g, b]
    end

    # Convert rgb channels into 8bit color
    def to_8bit(rgb)
      rgb = rgb.map do |c|
        c >>= 8
        if c < 0x00
          0
        elsif c > 0xFF
          0xFF
        else
          c
        end
      end
      rgb
    end

    # create a color string from a channel array
    def color_str(str, p)
      format(str, p[0], p[1], p[2])
    end

    # A hex color string (for rainbow)
    def hex(p)
      color_str('%02x%02x%02x', to_8bit(p))
    end

    # A truecolor background colorstring
    def true_bg(p)
      color_str("\x1b[48;2;%d;%d;%dm", to_8bit(p))
    end

    # A truecolor foreground colorstring
    def true_fg(p)
      color_str("\x1b[38;2;%d;%d;%dm", to_8bit(p))
    end

    # Get row indexes
    def for_row_indexes
      if @hd
        0.upto((@image.rows - 1) / 2)
      else
        0.upto(@image.rows - 1)
      end
    end

    def make_block(p)
      if @hd
        make_block_hd(p)
      else
        if @true_color
          block = true_bg(p) + ' '
        else
          block = ' '.background Rainbow::Color.parse_hex_color(hex(p))
        end
        block
      end
    end

    def make_block_hd(p)
      p0, p1 = p
      if @true_color
        block = true_bg(p0) + true_fg(p1) + '▄'
      else
        block = '▄'
                .background(Rainbow::Color.parse_hex_color(hex p0))
                .foreground(Rainbow::Color.parse_hex_color(hex p1))
      end
      block
    end
  end
end
