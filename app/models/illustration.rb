class Illustration < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  after_create :move_from_holding_location
  before_destroy :remove_assets

  
  def self.relative_tmp
    "illustrations/tmp"
  end

  def self.relative_final
    "illustrations"
  end

  def self.tmp_root
    File.join(Ekawada::Application::PUBLIC, relative_tmp)
  end

  def self.final_root
    File.join(Ekawada::Application::PUBLIC, relative_final)
  end

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

    relative_dir = File.join(relative_tmp, location)
    dir = File.join(tmp_root, location)

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

    system "/opt/local/bin/convert #{original} -resize 80x80 #{thumb}"
    system "/opt/local/bin/convert #{original} -resize 160x160 #{small}"
    system "/opt/local/bin/convert #{original} -resize 600x600 #{large}"

    size = File.size(original) + File.size(thumb) + File.size(small) + File.size(large)

    new(:location => location, :caption => name, :width => width, :height => height,
      :extension => ext, :file_size => size)
  end

  def url(which)
    relative = new_record? ? self.class.relative_tmp : self.class.relative_final
    File.join("", relative, location, "#{which}.#{extension}")
  end

  def path(which)
    File.join(Ekawada::Application::PUBLIC, url(which))
  end

  def aspect_ratio
    @aspect_ratio ||= width / height.to_f
  end

  def dimensions(which)
    return "#{width}x#{height}" if which == :original

    max = case which
      when :thumb then 80
      when :small then 160
      when :large then 600
      else raise ArgumentError, "unknown image type: #{which.inspect}"
      end

    if width > height
      x = max
      y = max/aspect_ratio
    else
      y = max
      x = y*aspect_ratio
    end

    "#{x.to_i}x#{y.to_i}"
  end

  private # --------------------------------------------------------------

  def move_from_holding_location
    final_location = File.join(parent.illustration_path, id.to_s)
    holding = File.join(self.class.tmp_root, location)
    final = File.join(self.class.final_root, final_location)

    update_attribute :location, final_location

    FileUtils.mkdir_p(File.dirname(final))
    FileUtils.mv(holding, final)
  end

  def remove_assets
    [:thumb, :small, :large, :original].each do |which|
      FileUtils.rm_f(path(which))
    end
  end
end
