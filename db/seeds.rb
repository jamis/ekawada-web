if Rails.env.development?
  def seeds(which)
    YAML.load_file(File.join(File.dirname(__FILE__), "seeds", "#{which}.yml"))
  end

  module UploadedFile
    attr_accessor :original_filename
  end

  user = User.create!(:name => "Test", :login => "test", :email => "test@example.com",
    :password => "test")

  sources = seeds(:sources).inject({}) do |map, (id, data)|
    type = data[:type]
    map.merge(id => type.classify.constantize.create(data))
  end

  seeds(:figures).each do |data|
    constructions = data.delete(:constructions)

    source_data = Array(data.delete(:sources))
    source_data.each do |entry|
      entry[:key], entry[:source] = entry[:source], sources[entry[:source]]
    end

    aliases = Array(data.delete(:aliases))
    illustrations = Array(data.delete(:illustrations))

    Figure.create(data).tap do |figure|
      aliases.each do |data|
        figure.aliases.create(data)
      end

      refmap = {}
      source_data.inject({}) do |map, entry|
        key = entry.delete(:key)
        refmap[key] = figure.figure_sources.create(entry)
      end

      illustrations.each do |i|
        filename = i.delete(:file)
        File.open(File.join(File.dirname(__FILE__), "seeds", "illustrations", filename)) do |file|
          file.extend(UploadedFile)
          file.original_filename = filename
          illustration = Illustration.process_to_holding(:file => file)
          illustration.update_attributes(i.merge(:parent => figure))
        end
      end

      constructions.each do |data|
        references = Array(data.delete(:references))
        illustrations = Array(data.delete(:illustrations))

        figure.constructions.create(data.merge(:submitter => user)).tap do |c|
          references.each do |ref|
            source = ref.delete(:source)
            ref[:figure_source] = refmap[source]
            c.references.create(ref)
          end

          illustrations.each do |i|
            filename = i.delete(:file)
            File.open(File.join(File.dirname(__FILE__), "seeds", "illustrations", filename)) do |file|
              file.extend(UploadedFile)
              file.original_filename = filename
              illustration = Illustration.process_to_holding(:file => file)
              illustration.update_attributes(i.merge(:parent => c))
            end
          end
        end
      end
    end
  end
end
