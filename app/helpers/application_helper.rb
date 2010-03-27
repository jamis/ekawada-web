module ApplicationHelper
  def markdown2html(text, paragraphs=false)
    text = BlueCloth.new(text).to_html
    text.gsub!(/<\/?p>/, "") unless paragraphs
    return text.html_safe
  end
end
