require 'test_helper'

class CloudsharesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get cloudshares_create_url
    assert_response :success
  end

end
