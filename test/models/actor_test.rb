require "test_helper"

class ActorTest < ActiveSupport::TestCase
  test "#block!" do
    actor = actors(:discoverable)

    actor.block!

    assert actor.blocked?
    assert actor.content_objects.none?
  end
end
