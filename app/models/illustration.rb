class Illustration < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  def self.generate_location
    "%f.%d.%s%s" %
      [Time.now, $$, rand(0xFFFFFFFF).to_s(36), rand(0xFFFFFFFF).to_s(36)]
  end

  def self.process_to_holding(data)
    name = data[:file].original_filename
    ext = name[/\.([^.]+)$/, 1]
    raise ArgumentError, "missing extension on file: #{name.inspect}" unless ext
    ext = ext.downcase

    location = generate_location

    relative_dir = File.join("illustrations", "tmp", location)
    dir = File.join(Rails.root, "public", relative_dir)

    FileUtils.mkdir_p(dir)

    original = File.join(dir, "original.#{ext}")
    thumb    = File.join(dir, "thumb.#{ext}")
    small    = File.join(dir, "small.#{ext}")
    large    = File.join(dir, "large.#{ext}")

    File.open(original, "wb") do |out|
      while chunk = data[:file].read(8192)
        out.write(chunk)
      end
    end

    width, height = `/opt/local/bin/identify -format "%w %h" #{original}`.
      strip.split.map(&:to_i)

    x, y = width, height
    dx = dy = 0

    if width > height
      dx = (width - height) / 2
      x = height
    else
      dy = (height - width) / 2
      y = width
    end

    crop = "#{x}x#{y}+#{dx}+#{dy}"

    system "/opt/local/bin/convert #{original} -crop #{crop} -resize 80x80 #{thumb}"
    system "/opt/local/bin/convert #{original} -crop #{crop} -resize 160x160 #{small}"
    system "/opt/local/bin/convert #{original} -resize 600x600 #{large}"

    size = File.size(original) + File.size(thumb) + File.size(small) + File.size(large)

    new(:location => location, :caption => name, :width => width, :height => height,
      :extension => ext, :file_size => size)
  end

  def url(which)
    if new_record?
      "/illustrations/tmp/#{location}/#{which}.#{extension}"
    else
      "/illustrations/#{location}/#{which}.#{extension}"
    end
  end
end
