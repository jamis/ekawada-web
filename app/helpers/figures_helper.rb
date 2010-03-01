module FiguresHelper
  def alias_locations_for(alt)
    if alt.location.present?
      content_tag(:span, " in ", :class => "preposition") +
      content_tag(:span, alt.location, :class => "locations")
    end
  end
end
