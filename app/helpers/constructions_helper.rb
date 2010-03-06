module ConstructionsHelper
  def each_step(construction, &block)
    start_at = construction.start_at
    n = 0
    construction.steps.each do |step|
      if step.silent?
        number = ""
      else
        number = construction.notation.format_step_number(start_at + n)
        n += 1
      end

      safe_concat(capture(number, step, &block))
    end
  end

  def notation_options
    Notation.types.map { |type| [type.name, type.id] }
  end

  def format_instruction(step)
    if step.wants_paragraphs?
      step.instruction.split(/\n/).map do |line|
        content_tag(:p, format_line(step, line).html_safe)
      end.join("\n").html_safe
    else
      format_line(step, step.instruction).html_safe
    end
  end

  def format_line(step, line)
    line.gsub(/\{i:(\d+)(?::(.*?))?\}/) do |m|
      number = $1.to_i
      caption = $2

      illustration = step.construction.illustrations.at(number)
      if illustration
        caption = illustration.caption unless caption.present?
        link_to(caption, "#", "data-behaviors" => "zoom-illustration", "data-illustration" => dom_id(illustration))
      else
        content_tag(:span, "no such illustration ##{number}", :class => "error")
      end
    end
  end

  def illustration_dom_id(illustration)
    if illustration.new_record?
      "thumb." + illustration.location
    else
      dom_id(illustration)
    end
  end
end
