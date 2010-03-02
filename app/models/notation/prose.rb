class Notation::Prose < Notation
  def parse(definition)
    position = 0
    instruction = []

    complete = Proc.new do
      yield position, interpret_step_data(extract_step_data(instruction.join("\n")))
      instruction.clear
      position += 1
    end

    definition.each_line do |line|
      line.strip!
      if line.empty? && instruction.any?
        complete.call
      else
        instruction << line
      end
    end

    complete.call if instruction.any?
    position
  end

  def extract_step_data(instruction)
    { :instruction => instruction }
  end
end
