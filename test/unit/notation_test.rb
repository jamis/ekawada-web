require 'test_helper'

class NotationTest < ActiveSupport::TestCase
  test "parsing default notation should extract one step per line" do
    assert_equal 3, parse(:default, "1. first\n2. second\n3. third")
    assert_parsed_as Notation
    assert_step 0, :instruction => "first", :type => nil, :name => nil, :figure => nil
    assert_step 1, :instruction => "second", :type => nil, :name => nil, :figure => nil
    assert_step 2, :instruction => "third", :type => nil, :name => nil, :figure => nil
  end

  test "parsing should extract make lines" do
    assert_equal 3, parse(:isfa, "1. {make:Opening A}.\n2. second\n3. third")
    assert_parsed_as Notation
    assert_step 0, :instruction => "{make}.", :type => "make", :duplicate => constructions(:openinga_isfa)
  end

  test "parsing should extract range lines" do
    assert_equal 3, parse(:isfa, "1. {make:Opening A:2:4}.\n2. second\n3. third")
    assert_parsed_as Notation
    assert_step 0, :instruction => "{make}.", :type => "range", :from => 2, :to => 4, :duplicate => constructions(:openinga_isfa)
  end

  test "parsing multiple make lines in a single step should cause error" do
    assert_raise ArgumentError do
      parse(:isfa, "1. {make:Position 1} and then {make:Opening A}.\n")
    end
  end

  test "parsing prose should treat newlines as the step separator" do
    assert_equal 2, parse(:prose, <<-STEPS)
First line of step 1.
Second line of step 1.

First line of step 2.
STEPS
    assert_parsed_as Notation::Prose
    assert_step 0, :instruction => "First line of step 1.\nSecond line of step 1.", :type => nil
    assert_step 1, :instruction => "First line of step 2.", :type => nil
  end

  test "parsing mizz code should extract comments" do
    assert_equal 2, parse(:mizz, "1 1-5,s (first position)\n2 L5ab")
    assert_parsed_as Notation::Mizz
    assert_step 0, :instruction => "1-5,s", :comment => "first position"
  end

  test "parsing mizz code should extract named figures" do
    assert_equal 3, parse(:mizz, "1 1-5,s\n2 R2,p/\n3 L2,2p/ [base]")
    assert_parsed_as Notation::Mizz
    assert_step 2, :instruction => "L2,2p/", :name => "base"
  end

  test "parsing mizz code should extract referenced figures" do
    assert_equal 3, parse(:mizz, "1 1-5,s\n2 R2,p/\n3 L2,2p/ [{base}]")
    assert_parsed_as Notation::Mizz
    assert_step 2, :instruction => "L2,2p/", :name => nil, :figure => figures(:openinga)
  end

  private

    def parse(as, definition)
      @steps = []
      @notation = Notation.new(as.to_s)
      @notation.parse(definition) do |pos, result|
        assert_equal pos, @steps.length
        @steps << result
      end
      @steps.length
    end

    def assert_parsed_as(klass)
      assert_equal klass, @notation.class
    end

    def assert_step(index, attributes)
      step = @steps[index]

      attributes.each do |key, value|
        case key
        when :type then
          assert_equal value, step[:duplicate_type]
        when :from then
          assert_equal value, step[:duplicate_from]
        when :to then
          assert_equal value, step[:duplicate_to]
        else
          assert_equal value, step[key], "expected #{key.inspect} to be #{value.inspect}"
        end
      end
    end
end