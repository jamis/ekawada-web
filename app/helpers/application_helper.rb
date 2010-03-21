module ApplicationHelper
  def markdown2html(text)
    BlueCloth.new(text).to_html.html_safe
  end
end
