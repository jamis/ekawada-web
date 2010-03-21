require 'test_helper'

class FigureTest < ActiveSupport::TestCase
  LABRETS = <<-STEPS
0 {make:base}
1 1ad,(2 5b*)5a
2 2
3 SPR
STEPS

  test "create with construction data should create construction" do
    figure = Figure.create(:canonical_name => "Labrets",
      :submitter_id => users(:jamis).id,
      :construction => { :notation_id => "mizz", :definition => LABRETS })
    assert_equal 4, figure.constructions.first.steps.length
    assert_equal "mizz", figure.constructions.first.notation_id
    assert_equal users(:jamis), figure.constructions.first.submitter
    assert_equal "Labrets", figure.canonical_name
  end

  test "create with alias data should create aliases" do
    figure = Figure.create(:canonical_name => "Labrets",
      :new_aliases => [
        { :name => "Grandma's Walking Sticks", :location => "" },
        { :name => "Something else", :location => "Somewhere" }])
    assert_equal 2, figure.aliases.length
    assert_equal ["Grandma's Walking Sticks:", "Something else:Somewhere"],
      figure.aliases.map { |a| "#{a.name}:#{a.location}" }.sort
  end

  test "find_by_name should find figure by canonical name" do
    assert_equal figures(:position1), Figure.find_by_name("Position 1")
  end

  test "find_by_name should find figure by alias if no canonical name matches" do
    assert_equal figures(:position1), Figure.find_by_name("First Position")
  end

  test "find_by_name should find figure by construction name if no canonical name or alias matches" do
    assert_equal figures(:openinga), Figure.find_by_name("base")
  end

  test "find_by_name should return nil if no figure can be found with that name" do
    assert_nil Figure.find_by_name("bogus name")
  end

  test "update with old alias data should update existing aliases" do
    id = aliases(:first_position).id
    figures(:position1).update_attributes(
      :old_aliases => { id => { :id => id,
          :deleted => "0",
          :name => "1st position",
          :location => "everywhere" } }
      )

    assert_equal "1st position", aliases(:first_position, :reload).name
    assert_equal "everywhere", aliases(:first_position).location
  end

  test "update with old alias data should delete marked aliases" do
    id = aliases(:first_position).id
    figures(:position1).update_attributes(
      :old_aliases => { id => { :id => id,
          :deleted => "1",
          :name => "1st position",
          :location => "everywhere" } }
      )

    assert !Alias.exists?(id)
  end
end
