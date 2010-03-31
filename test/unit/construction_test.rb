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

  test "updating a construction should add references" do
    assert_difference "constructions(:position1_isfa).references.count" do
      constructions(:position1_isfa).update_attributes(
        :referenced_sources => {
          figure_sources(:cfj_position1) => "1"
        })
    end
  end

  test "updating a construction should remove references" do
    assert constructions(:openinga_isfa).references.any?

    assert_difference "constructions(:openinga_isfa).references.count", -1 do
      constructions(:openinga_isfa).update_attributes(
        :referenced_sources => {
          figure_sources(:cfj_openinga) => "0"
        })
    end

    assert constructions(:openinga_isfa, :reload).references.empty?
  end

  test "updating a construction without specifying references shouldn't modify references" do
    assert constructions(:openinga_isfa).references.any?

    assert_no_difference "constructions(:openinga_isfa).references.count" do
      constructions(:openinga_isfa).update_attributes :name => "Opening Alpha"
    end

    assert constructions(:openinga_isfa, :reload).references.any?
  end

  test "updating the notation_id should force definition to be reparsed" do
    ids = constructions(:openinga_isfa).steps.map(&:id).sort
    constructions(:openinga_isfa).update_attribute(:notation_id, "other")
    new_ids = constructions(:openinga_isfa, :reload).steps.map(&:id).sort
    assert_not_equal ids, new_ids
  end
end
