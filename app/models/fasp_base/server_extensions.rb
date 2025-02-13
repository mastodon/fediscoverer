module FaspBase::ServerExtensions
  def enable_capability!(capability, version:)
    super

    create_subscriptions if capability == "data_sharing"
  end

  def disable_capability!(capability, version:)
    super

    destroy_subscriptions if capability == "data_sharing"
  end

  private

  def create_subscriptions
    FaspDataSharing::Subscription.subscribe_to_content(self)
    FaspDataSharing::Subscription.subscribe_to_accounts(self)
    FaspDataSharing::Subscription.subscribe_to_trends(self, threshold: {
      timeframe: 10,
      shares: 3,
      likes: 3,
      replies: 3
    })
  end

  def destroy_subscriptions
    FaspDataSharing::Subscription.where(fasp_base_server: self).destroy_all
  end
end
