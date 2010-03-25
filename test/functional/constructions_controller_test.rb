require 'test_helper'

class ConstructionsControllerTest < ActionController::TestCase
  test "new should respond correctly for authenticated user" do
    login(:jamis)
    get :new, :figure_id => figures(:openinga).id
    assert_redirected_to figure_url(figures(:openinga), :anchor => "new_construction")
  end

  test "new should 403 for unauthenticated user" do
    get :new, :figure_id => figures(:openinga).id
    assert_response :forbidden
  end

  test "create should respond correctly for authenticated user" do
    login(:jamis)
    assert_difference "figures(:openinga).constructions.count" do
      post :create, :figure_id => figures(:openinga).id,
        :construction => { :notation_id => "prose", :definition => "this\n\nthat" }
      assert_redirected_to assigns(:construction)
    end
  end

  test "create should 403 for unauthenticated user" do
    assert_no_difference "figures(:openinga).constructions.count" do
      post :create, :figure_id => figures(:openinga).id,
        :construction => { :notation_id => "prose", :definition => "this\n\nthat" }
      assert_response :forbidden
    end
  end

  test "show should respond correctly" do
    cons = constructions(:position1_isfa)
    get :show, :id => cons.id
    assert_redirected_to figure_url(cons.figure, :anchor => ActionController::RecordIdentifier.dom_id(cons))
  end

  test "edit should respond correctly for authenticated user" do
    login(:jamis)
    get :edit, :id => constructions(:position1_isfa).id
    assert_response :success
    assert_template "constructions/edit"
  end

  test "edit should 403 for unauthenticated user" do
    get :edit, :id => constructions(:position1_isfa).id
    assert_response :forbidden
  end

  test "update should respond correctly for authenticated user" do
    login(:jamis)
    put :update, :id => constructions(:position1_isfa).id,
      :construction => { :name => "nifty!" }
    assert_redirected_to(constructions(:position1_isfa))
    assert_equal "nifty!", constructions(:position1_isfa, :reload).name
  end

  test "update should 403 for unauthenticated user" do
    put :update, :id => constructions(:position1_isfa).id,
      :construction => { :name => "nifty!" }
    assert_response :forbidden
    assert_not_equal "nifty!", constructions(:position1_isfa, :reload).name
  end

  test "destroy should respond correctly for authenticated user" do
    login(:jamis)
    assert_difference "Construction.count", -1 do
      delete :destroy, :id => constructions(:position1_isfa).id
    end

    assert_redirected_to figure_url(figures(:position1))
  end

  test "destroy should 403 for unauthenticated user" do
    assert_no_difference "Construction.count" do
      delete :destroy, :id => constructions(:position1_isfa).id
      assert_response :forbidden
    end
  end
end
