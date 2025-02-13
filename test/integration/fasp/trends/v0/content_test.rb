require "test_helper"

class Fasp::Trends::V0::ContentTest < ActionDispatch::IntegrationTest
  setup do
    @server = fasp_base_servers(:mastodon_server)
  end

  test "unauthenticated access is prohibited" do
    get fasp_trends_v0_contents_path, as: :json

    assert_response :unauthorized
  end

  test "authenticated request returns results successfully" do
    authenticated_headers = request_authentication_headers(@server, :get, fasp_trends_v0_contents_url, "")

    get fasp_trends_v0_contents_path, as: :json, headers: authenticated_headers

    assert_response :ok
  end
end
