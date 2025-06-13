require "test_helper"

class ServerTest < ActiveSupport::TestCase
  test "#block! sets `blocked` flag an deletes actors and content" do
    server = servers(:mastodon)

    server.block!

    assert server.blocked?
    assert server.actors.none?
  end
end
