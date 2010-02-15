module ConstructionsHelper
  def each_step(construction, &block)
    start_at = construction.meta.start_at
    n = 0
    construction.steps.each do |step|
      if step.silent?
        number = ""
      else
        number = construction.meta.format_step_number(start_at + n)
        n += 1
      end

      safe_concat(capture(number, step, &block))
    end
  end

  def notation_options
    Notation::MAP.keys.sort_by { |k| Notation::MAP[k] }.map { |k| [Notation::MAP[k], k] }
  end
end
