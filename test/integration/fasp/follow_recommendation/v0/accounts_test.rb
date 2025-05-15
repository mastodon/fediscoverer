require "test_helper"

class Fasp::FollowRecommendation::V0::AccountsTest < ActionDispatch::IntegrationTest
  setup do
    @server = fasp_base_servers(:mastodon_server)
    @requesting_actor = actors(:discoverable)
  end

  test "unauthenticated access is prohibited" do
    get fasp_follow_recommendation_v0_accounts_path(accountUri: @requesting_actor.uri), as: :json

    assert_response :unauthorized
  end

  test "authenticated request returns results successfully" do
    account_uri = @requesting_actor.uri
    authenticated_headers = request_authentication_headers(@server, :get, fasp_follow_recommendation_v0_accounts_url(accountUri: account_uri), "")

    get fasp_follow_recommendation_v0_accounts_path(accountUri: account_uri), as: :json, headers: authenticated_headers

    assert_response :ok
    parsed_response = JSON.parse(response.body)

    assert parsed_response.is_a?(Array)
    assert !parsed_response.empty?
  end
end
