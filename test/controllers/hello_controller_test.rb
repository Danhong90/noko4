require 'test_helper'

class HelloControllerTest < ActionController::TestCase
  test "should get noko" do
    get :noko
    assert_response :success
  end

end
