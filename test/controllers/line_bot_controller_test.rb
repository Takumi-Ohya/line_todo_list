require 'test_helper'

class LineBotControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get line_bot_callback_url
    assert_response :success
  end

end
