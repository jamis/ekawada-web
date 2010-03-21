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
end
