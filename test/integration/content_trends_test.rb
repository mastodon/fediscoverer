require "test_helper"

class ContentTrendsTest < ActionDispatch::IntegrationTest
  test "unauthenticated access is prohibited" do
    get content_trends_path

    assert_redirected_to fasp_base.new_session_path
  end

  test "authenticated request returns results successfully" do
    sign_in

    get content_trends_path

    assert_response :ok
  end
end
