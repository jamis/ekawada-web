module SourcesHelper
  def source_type(kind)
    case kind.to_s
    when 'online' then "website"
    else kind
    end
  end
end
