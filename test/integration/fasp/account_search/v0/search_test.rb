require "test_helper"

class Fasp::AccountSearch::V0::SearchTest < ActionDispatch::IntegrationTest
  setup do
    @server = fasp_base_servers(:mastodon_server)
  end

  test "unauthenticated access is prohibited" do
    get fasp_account_search_v0_search_path(term: "please"), as: :json

    assert_response :unauthorized
  end

  test "authenticated request returns results successfully" do
    term = "please"
    authenticated_headers = request_authentication_headers(@server, :get, fasp_account_search_v0_search_url(term:), "")

    get fasp_account_search_v0_search_path(term:), as: :json, headers: authenticated_headers

    assert_response :ok
    parsed_response = JSON.parse(response.body)

    assert parsed_response.is_a?(Array)
    assert_equal 20, parsed_response.size
  end
end
