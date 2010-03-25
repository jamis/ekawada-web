require 'test_helper'

class FigureSourcesControllerTest < ActionController::TestCase
  test "new should respond correctly for authenticated user" do
    login(:jamis)
    get :new, :figure_id => figures(:openinga).id
    assert_response :success
    assert_template "figure_sources/new"
  end

  test "new should 403 for unauthenticated user" do
    get :new, :figure_id => figures(:openinga).id
    assert_response :forbidden
  end

  test "create should respond correctly for authenticated user" do
    login(:jamis)
    assert_difference "figures(:openinga).figure_sources.count" do
      post :create, :figure_id => figures(:openinga).id,
        :figure_source => {
          :which_source => "existing",
          :kind => "book",
          :source_id => sources(:cfj).id,
          :info_section => "Chapter 2",
          :info_pages => "Pg. 11" }
    end

    assert_redirected_to figures(:openinga)
  end

  test "create should 403 for unauthenticated user" do
    assert_no_difference "figures(:openinga).figure_sources.count" do
      post :create, :figure_id => figures(:openinga).id,
        :figure_source => {
          :which_source => "existing",
          :kind => "book",
          :source_id => sources(:cfj).id,
          :info_section => "Chapter 2",
          :info_pages => "Pg. 11" }
      assert_response :forbidden
    end
  end
end
