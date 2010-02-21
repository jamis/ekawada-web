if Rails.env.development?
  def seeds(which)
    YAML.load_file(File.join(File.dirname(__FILE__), "seeds", "#{which}.yml"))
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

    Figure.create(data).tap do |figure|
      aliases.each do |data|
        figure.aliases.create(data)
      end

      refmap = {}
      source_data.inject({}) do |map, entry|
        key = entry.delete(:key)
        refmap[key] = figure.figure_sources.create(entry)
      end

      constructions.each do |data|
        references = Array(data.delete(:references))
        figure.constructions.create(data.merge(:submitter => user)).tap do |c|
          references.each do |ref|
            source = ref.delete(:source)
            ref[:figure_source] = refmap[source]
            c.references.create(ref)
          end
        end
      end
    end
  end
end
