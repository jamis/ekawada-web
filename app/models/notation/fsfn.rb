class Notation::Fsfn < Notation
  # fsfn does not number instruction lines
  def format_step_number(number)
    ""
  end

  def format_comment(comment)
    "# #{comment}"
  end

  def match_line(line)
    [nil, line.match(/^\s*(.*?)\s*$/)[1]]
  end

  def extract_step_data(line, instruction)
    instruction = instruction.strip.sub(/\[(.*?)\]/) { "[{make:#{$1}}]" }
    instruction, comment = instruction.split(/#/, 2)

    instruction = instruction.strip if instruction
    comment = comment.strip if comment
      
    { :instruction => instruction.present? ? instruction : nil,
      :comment => comment }
  end
end
