require "test_helper"

class LinkTrendsTest < ActionDispatch::IntegrationTest
  test "unauthenticated access is prohibited" do
    get link_trends_path

    assert_redirected_to fasp_base.new_session_path
  end

  test "authenticated request returns results successfully" do
    sign_in

    get link_trends_path

    assert_response :ok
  end
end
