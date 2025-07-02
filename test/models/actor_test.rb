require "test_helper"

class ActorTest < ActiveSupport::TestCase
  test "#block!" do
    actor = actors(:discoverable)

    actor.block!

    assert actor.blocked?
    assert actor.content_objects.none?
  end

  test "#content_indexable? only returns true when actor is discoverable, indexable and not blocked" do
    not_discoverable = actors(:not_discoverable)
    refute not_discoverable.content_indexable?

    discoverable_not_indexable = actors(:discoverable_not_indexable)
    refute discoverable_not_indexable.content_indexable?

    indexable_not_discoverable = actors(:indexable_not_discoverable)
    refute indexable_not_discoverable.content_indexable?

    blocked = actors(:blocked)
    refute blocked.content_indexable?

    discoverable = actors(:discoverable)
    assert discoverable.content_indexable?
  end
end
