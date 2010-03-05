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
        content_tag(:p, line)
      end.join("\n").html_safe
    else
      step.instruction
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
