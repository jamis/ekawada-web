module ConstructionsHelper
  def each_step(construction, &block)
    start_at = construction.start_at
    n = 0
    construction.steps.each do |step|
      if step.silent?
        number = ""
      else
        if step.range?
          size = step.duplicate_to - step.duplicate_from
          number = "#{start_at + n}&ndash;#{start_at + n + size}"
          n += size + 1
        else
          number = start_at + n
          n += 1
        end
      end

      number = construction.notation.format_step_number(number)
      safe_concat(capture(number, step, &block))
    end
  end

  def notation_options
    Notation.types.map { |type| [type.name, type.id] }
  end

  def format_instruction(step)
    if step.wants_paragraphs?
      apply_formatting(step, step.instruction).split(/\n/).map do |line|
        content_tag(:p, format_line(step, line).html_safe)
      end.join("\n").html_safe
    else
      format_line(step, apply_formatting(step, step.instruction)).html_safe
    end
  end

  def apply_formatting(step, text)
    if step.construction.notation.rich_format?
      markdown2html(text)
    else
      text
    end
  end

  def format_line(step, line)
    (line || "").gsub(/\{(.*?)\}/) do |m|
      case $1
      when /^i:(.*)$/
        format_illustration(step, $1)
      when "make"
        if step.make? || step.range?
          link_to(step.duplicate.figure_name, construction_path(step.duplicate))
        else
          content_tag(:span, "\"make\" directive present, but step has no referenced construction", :class => "error")
        end
      else
        content_tag(:span, "unrecognized directive \"#{$1}\"", :class => "error")
      end
    end
  end

  def format_illustration(step, definition)
    if definition =~ /^(\d+)(?::(.*?))?$/
      number = $1.to_i
      caption = $2

      illustration = step.construction.illustrations.at(number)
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

  def illustration_dom_id(illustration)
    if illustration.new_record?
      "thumb." + illustration.location
    else
      dom_id(illustration)
    end
  end

  def reference_check_box(form, construction, figure_source)
    name = form.object_name + "[#{figure_source.id}]"
    hidden = hidden_field_tag(name, "0")
    checkbox = check_box_tag(name, "1", construction.references.any? { |ref| ref.figure_source_id == figure_source.id })
    hidden + checkbox
  end
end
