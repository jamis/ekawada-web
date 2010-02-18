module FiguresHelper
  def alias_locations_for(alt)
    if alt.locations.any?
      content_tag(:span, " in ", :class => "preposition") +
      content_tag(:span, alt.locations.to_sentence, :class => "locations")
    end
  end
end
