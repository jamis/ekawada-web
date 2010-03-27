class Notation::Sfn < Notation
  def format_comment(comment)
    "(#{comment})"
  end

  def rich_format?
    false
  end

  def extract_step_data(line, instruction)
    instruction = instruction.strip

    if instruction =~ /^\((.*)\)$/
      comment = $1
      instruction = nil
    end

    { :instruction => instruction.present? ? instruction : nil,
      :comment => comment }
  end
end
