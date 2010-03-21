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

  test "edit should respond correctly" do
    get :edit, :id => figures(:openinga).id
    assert_response :success
    assert_template "figures/edit"
  end

  test "update should respond correctly" do
    put :update, :id => figures(:openinga).id,
      :figure => { :canonical_name => "Opening Alpha" }
    assert_redirected_to figure_url(figures(:openinga))
    assert_equal "Opening Alpha", figures(:openinga, :reload).canonical_name
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

  test "destroy should respond correctly" do
    assert_difference "Figure.count", -1 do
      delete :destroy, :id => figures(:openinga).id
      assert_redirected_to root_url
    end
  end
end
