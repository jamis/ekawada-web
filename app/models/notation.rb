class Notation
  include Comparable

  class <<self
    alias_method :make, :new

    def new(id)
      CACHE[id] ||= implementation_for(id).make(id, INFO[id])
    end

    def implementation_for(id)
      ("Notation::" + id.underscore.classify).constantize
    rescue NameError
      self
    end

    def types
      @types ||= INFO.keys.map { |id| new(id) }.sort
    end
  end

  attr_reader :id

  def initialize(id, attributes)
    @id = id
    @attributes = attributes
  end
  
  def has_short_name?
    name(:short) != name
  end

  def name(type=:full)
    case type
    when :full then @attributes["full"]
    when :short then @attributes["short"] || @attributes["full"]
    else raise ArgumentError, "unknown name type: #{type.inspect}"
    end
  end

  def resources
    @attributes["resources"]
  end

  def <=>(notation)
    self.to_i <=> notation.to_i
  end

  def to_i
    @attributes["sort"].to_i
  end

  def to_s
    name
  end

  def to_param
    id
  end

  def parse(definition)
    position = 0

    definition.each_line do |line|
      line.strip!
      next if line.empty?

      number, instruction = match_line(line)
      number = number.to_i if number.present?

      yield position, interpret_step_data(extract_step_data(line, instruction))
      position += 1
    end

    position
  end

  def match_line(line)
    line.match(/^\s*(?:(\d+)\.?\s+)?(\S.*)$/)[1,2]
  end

  def extract_step_data(line, instruction)
    { :instruction => instruction.strip }
  end

  # Steps begin counting at #1, in general. Subclasses may override this for
  # notations with different behavior (like mizz code, which may start at 0)
  def start_at(options={})
    1
  end

  # Format the given number for use as a step number. Subclasses may override
  # this for notations that format the number differently (like mizz code or
  # SFN, which omit the period after the step number).
  def format_step_number(number)
    "#{number}. "
  end

  # Format the comment according to this notation's style. Most notations don't
  # have any concept of a "comment", so subclasses ought to redefine this as
  # necessary.
  def format_comment(comment)
    comment
  end

  def interpret_step_data(data)
    if data[:instruction]
      data[:instruction].gsub!(/\{(.*?)\}/) do |m|
        directive = $1

        case directive
        when /^make:/
          if data[:duplicate]
            raise ArgumentError, "cannot provide more than a single \"make\" directive per step"
          end

          case directive
          when /^make:(.*?):(\d+):(\d+)$/
            data[:duplicate_type] = "range"
            data[:duplicate_from] = $2.to_i
            data[:duplicate_to] = $3.to_i
            data[:duplicate] = Construction.find_best_match($1, id)
          when /^make:(.*)$/
            data[:duplicate_type] = "make"
            data[:duplicate] = Construction.find_best_match($1, id)
          else raise ArgumentError, "unknown make directive: #{directive.inspect}"
          end

          "{make}"
        when /^i:/
          # processed at render-time
          "{#{directive}}"
        else raise ArgumentError, "unknown directive: #{directive.inspect}"
        end
      end
    end

    if data[:name] && data[:name] =~ /^\{(.*)\}$/
      data[:name] = nil
      data[:figure] = Figure.find_by_name($1)
    end

    data
  end

  CACHE = {}
  INFO  = YAML.load_file(File.join(Rails.root, "config", "notations.yml"))
end
