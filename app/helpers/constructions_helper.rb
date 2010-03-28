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

          if size == 0
            number = start_at + n
          else
            number = "#{start_at + n}&ndash;#{start_at + n + size}"
          end

          n += size + 1
        else
          number = start_at + n
          n += 1
        end

        number = construction.notation.format_step_number(number)
      end

      safe_concat(capture(number, step, &block))
    end
  end

  def notation_options
    Notation.types.map { |type| [type.name, type.id] }
  end

  def format_instruction(step)
    notation = step.construction.notation
    lines = notation.paragraphs? ? step.instruction.split("\n") : [step.instruction]

    lines.map do |line|
      line = format_text(line,
        :step => step, :rich => notation.rich_format?, :paragraphs => false
      ).html_safe

      line = content_tag(:p, line) if notation.paragraphs?
      line
    end.join("\n").html_safe
  end

  def format_comment(step)
    step.construction.notation.format_comment(
      format_text(step.comment, :step => step, :rich => true, :paragraphs => false)).html_safe
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
