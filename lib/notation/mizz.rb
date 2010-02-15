module Notation
  class Mizz < General
    def extract_step_data(line, instruction)
      instruction = instruction.strip
      instruction, name = extract_enclosed_text(instruction, ?[, ?])
      instruction, comment = extract_enclosed_text(instruction, ?(, ?))

      { :instruction => instruction.present? ? instruction : nil,
        :comment => comment,
        :name => name }
    end

    def extract_enclosed_text(text, start_char, end_char)
      if text[-1] == end_char
        depth = 1
        n = -1
        while text[n] && depth > 0
          n -= 1

          if text[n] == end_char
            depth += 1
          elsif text[n] == start_char
            depth -= 1
          end
        end

        if depth.zero? && text[n-1,1] == " "
          text, enclosed = text[0..(n-1)].strip, text[(n+1)..-2].strip
        end
      end

      [text,enclosed]
    end
  end
end
