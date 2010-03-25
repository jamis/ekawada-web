require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "new should render correctly" do
    get :new
    assert_response :success
    assert_template "sessions/new"
  end

  test "create without incorrect username should rerender login page" do
    post :create, :user => { :login => "abcxyz", :password => "..." }
    assert_redirected_to new_session_url
    assert flash.key?(:error)
  end

  test "create without incorrect password should rerender login page" do
    post :create, :user => { :login => users(:jamis).login, :password => "..." }
    assert_redirected_to new_session_url
    assert flash.key?(:error)
  end

  test "create with correct credentials should populate session and redirect" do
    post :create, :user => { :login => users(:jamis).login, :password => "password" }
    assert_redirected_to root_url
    assert_equal session[:user_id], users(:jamis).id
  end

  test "destroy should invalidate session" do
    session[:user_id] = users(:jamis).id
    delete :destroy
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
