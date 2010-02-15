module ConstructionsHelper
  def each_step(construction, &block)
    start_at = construction.meta.start_at
    construction.steps.each_with_index do |step, index|
      safe_concat(capture(construction.meta.format_step_number(start_at + index), step, &block))
    end
  end

  def notation_options
    Notation::MAP.keys.sort_by { |k| Notation::MAP[k] }.map { |k| [Notation::MAP[k], k] }
  end
end
