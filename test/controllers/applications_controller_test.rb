require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  def setup
  end

  test "should get new" do
    get new_application_path
    assert_response :success
  end
end
