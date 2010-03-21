require 'test_helper'

class FigureSourceTest < ActiveSupport::TestCase
  test "creating a figure source with an existing source" do
    assert_no_difference "Source.count" do
      figsrc = figures(:openinga).figure_sources.create!(
        :which_source => "existing",
        :new_source => { :should_be_ignored => true },
        :source_id => sources(:cfj).id,
        :info_section => "Chapter 2",
        :info_pages => "Pg. 11")
      assert figsrc.valid?
      assert_equal "Chapter 2", figsrc.info[:section]
      assert_equal "Pg. 11", figsrc.info[:pages]
      assert_equal sources(:cfj), figsrc.source
    end
  end

  test "creating a figure source with a new source" do
    assert_difference "Source.count" do
      figsrc = figures(:openinga).figure_sources.create!(
        :which_source => "new",
        :kind => "periodical",
        :new_source => { :title => "Bulletin of the International String Figure Association" },
        :source_id => 12345,
        :info_volume => "9",
        :info_date => "2002",
        :info_article => "More Figures from China",
        :info_authors => "Wirt, Will")
      assert figsrc.valid?
      assert_equal "9", figsrc.info[:volume]
      assert_equal "2002", figsrc.info[:date]
      assert_equal "More Figures from China", figsrc.info[:article]
      assert_equal "Wirt, Will", figsrc.info[:authors]
      assert_equal "Bulletin of the International String Figure Association", figsrc.source.title
      assert_equal :periodical, figsrc.source.kind
    end
  end
end
