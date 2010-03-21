require 'test_helper'

class SourcesControllerTest < ActionController::TestCase
  test "index should respond correctly" do
    get :index
    assert_response :success
    assert_template "sources/index"
  end
end
