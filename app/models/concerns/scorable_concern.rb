module ScorableConcern
  extend ActiveSupport::Concern

  included do
    before_save :calculate_score
  end

  private

  def calculate_score
    raise NotImplementedError
  end

  # We cannot trust these values, so we trim them to
  # a maximum value that cannot skew the score too
  # much.
  def trimmed_likes
    [ likes, 100 ].min / 10.0
  end

  def trimmed_shares
    [ shares, 100 ].min / 10.0
  end
end
