require 'test_helper'

class ConstructionTest < ActiveSupport::TestCase
  test "creating a construction should parse definition into steps" do
    construction = figures(:openinga).constructions.create(
      :notation_id => "other",
      :submitter => users(:jamis),
      :definition => "1. foo\n2. bar\n3. baz")

    assert_equal 3, construction.steps.length
    assert_equal %w(foo bar baz), construction.steps.map(&:instruction)
  end
end
