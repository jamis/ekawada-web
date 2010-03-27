module ApplicationHelper
  def markdown2html(text)
    BlueCloth.new(text).to_html.gsub(/<\/?p>/, "").html_safe
  end
end
