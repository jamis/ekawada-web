require 'test_helper'

class NotationsControllerTest < ActionController::TestCase
  Notation.types.each do |notation|
    test "show should respond correctly for #{notation.id} notation" do
      get :show, :id => notation.id
      assert_response :success
      assert_template "notations/show"
    end
  end
end
