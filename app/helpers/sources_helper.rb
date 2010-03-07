module SourcesHelper
  def source_template_for(source)
    source.class.name.underscore.sub(/_source$/, "")
  end
end
