module FormattingHelper
  def markdown2html(text, paragraphs=false)
    text = BlueCloth.new(text).to_html
    text.gsub!(/<\/?p>/, "") unless paragraphs
    return text.html_safe
  end

  def format_text(text, options={})
    text = markdown2html(text, options[:paragraphs]) if options[:rich]

    opts = options.dup
    opts[:construction] ||= opts[:step].construction if opts[:step]
    opts[:figure] ||= opts[:construction].figure if opts[:construction]
    opts[:notation] ||= opts[:construction].notation if opts[:construction]

    (text || "").gsub(/\{(.*?)\}/) do |m|
      case $1
      when /^url:(.*)$/   then format_url_for($1, opts)
      when /^a:(.*)$/     then format_anchor_for($1, opts)
      when /^i:(.*)$/     then format_illustration($1, opts)
      when "make"         then format_make(opts)
      when /make:([^:]+)/ then format_invalid_make($1, opts)
      else
        content_tag(:span, "unrecognized directive \"#{$1}\"", :class => "error")
      end
    end
  end

  def format_illustration(definition, options)
    if definition =~ /^(\d+)(?::(.*?))?$/
      number = $1.to_i
      caption = $2

      illustration = options[:construction].illustrations.at(number)
      if illustration
        caption = illustration.caption unless caption.present?
        link_to(caption, "#", "data-behaviors" => "zoom-illustration", "data-illustration" => dom_id(illustration))
      else
        content_tag(:span, "no such illustration ##{number}", :class => "error")
      end
    else
      content_tag(:span, "incorrect format for illustration", :class => "error")
    end
  end

  def format_make(opts)
    step = opts[:step]

    if step && (step.make? || step.range?)
      opts = { "data-behaviors" => "toggle-expand" }
      if step.range?
        opts["data-from"] = step.duplicate_from
        opts["data-to"] = step.duplicate_to
      end

      link_to(step.duplicate.figure_name, expand_construction_path(step.duplicate), opts)
    elsif step.nil?
      content_tag(:span, "\"make\" directive present, but no step information available")
    else
      content_tag(:span, "\"make\" directive present, but step has no referenced construction", :class => "error")
    end
  end

  def format_invalid_make(name, opts)
    name + " " +
      content_tag(:span, "(no figure by that name found in #{opts[:notation]})",
        :class => "error")
  end

  def format_url_for(name, opts)
    if opts[:notation]
      construction = Construction.find_best_match(name, opts[:notation].id)
      return construction_path(construction) if construction
    else
      figure = Figure.find_by_name(name)
      return figure_path(figure) if figure
    end

    return nil
  end

  def format_anchor_for(name, opts)
    url = format_url_for(name, opts)
    if url
      link_to(name, url)
    else
      content_tag(:span, "[no figure #{name.inspect} found]", :class => "error")
    end
  end
end
