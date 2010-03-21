require 'test_helper'

class FiguresControllerTest < ActionController::TestCase
  test "index should respond correctly" do
    get :index
    assert_response :success
    assert_template "figures/index"
  end

  test "show should respond correctly" do
    get :show, :id => figures(:openinga).id
    assert_response :success
    assert_template "figures/show"
  end

  test "new should respond correctly" do
    get :new
    assert_response :success
    assert_template "figures/new"
  end

  test "create should respond correctly" do
    assert_difference "Figure.count" do
      assert_difference "Construction.count" do
        assert_difference "Step.count", 5 do
          post :create, :figure => {
            :canonical_name => "A Man and a Bed",
            :construction => {
              :notation_id => "mizz",
              :definition => "0 {make:base}\n1 1,(2)5a\n2 5,(2a)1bi\n3 2\n4 SPR & display\n" } }
        end
      end
    end

    assert_redirected_to figure_url(assigns(:figure))
  end
end
