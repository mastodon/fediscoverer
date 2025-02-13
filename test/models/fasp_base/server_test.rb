require "test_helper"

class FaspBase::ServerTest < ActiveSupport::TestCase
  include FaspBase::IntegrationTestHelper

  setup do
    @server = fasp_base_servers(:mastodon_server)
    stub_request_to(@server, :post, "/data_sharing/v0/event_subscriptions", 201, { subscription: { id: "23" } })
    stub_request_to(@server, :delete, "/data_sharing/v0/event_subscriptions/23", 204)
  end

  test "enabling `data_sharing` creates subscriptions, disabling deletes them" do
    assert_difference -> { FaspDataSharing::Subscription.count }, 3 do
      @server.enable_capability!("data_sharing", version: 0)
    end

    assert_difference -> { FaspDataSharing::Subscription.count }, -3 do
      @server.disable_capability!("data_sharing", version: 0)
    end
  end
end
