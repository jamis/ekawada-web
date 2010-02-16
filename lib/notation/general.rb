module Notation
  class General
    def self.parse(figure, body, options={})
      new(figure, options).parse(body)
    end

    attr_reader :figure
    attr_reader :construction
    attr_reader :options

    def initialize(figure, options={})
      @figure = figure
      @construction = options[:construction].is_a?(Construction) ? options[:construction] : figure.constructions.build(options[:construction])
      @options = options
    end

    def parse(body)
      construction.steps.clear
      construction.definition = body
      construction.reviewed_at = construction.reviewed_by = nil

      body.split(/[\r\n]+/).each_with_index do |instruction, position|
        # skip blank lines
        next if instruction.strip.blank?

        # remove line numbers
        line, instruction = instruction.match(/^\s*(?:(\d+)[.\)\]:]?\s+)?(.*)$/)[1,2]
        line = line.to_i if line.present?

        step_data = extract_step_data(line, instruction)
        step_data = interpret_step_data(step_data)
        construction.steps.build(step_data.merge(:position => position+1))
      end

      construction
    end

    def extract_step_data(line, instruction)
      { :instruction => instruction.strip }
    end

    # Steps begin counting at #1, in general. Subclasses may override this for
    # notations with different behavior (like mizz code)
    def start_at
      1
    end

    def format_step_number(number)
      "#{number}. "
    end

    def interpret_step_data(data)
      if data[:instruction] && data[:instruction] =~ /^\{(.*)\}$/
        directive = $1
        data[:instruction] = nil

        case directive
        when /^make:(.*?):(\d+):(\d+)$/
          data[:duplicate_type] = "range"
          data[:duplicate_from] = $2.to_i
          data[:duplicate_to] = $3.to_i
          data[:duplicate] = Construction.find_best_match($1, construction.notation)
        when /^make:(.*)$/
          data[:duplicate_type] = "make"
          data[:duplicate] = Construction.find_best_match($1, construction.notation)
        else raise ArgumentError, "unknown directive: #{directive.inspect}"
        end
      end

      if data[:name] && data[:name] =~ /^\{(.*)\}$/
        data[:name] = nil
        data[:figure] = Figure.find_by_common_name($1)
      end

      data
    end
  end
end
