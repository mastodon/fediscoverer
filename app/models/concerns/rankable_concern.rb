module RankableConcern
  extend ActiveSupport::Concern

  def rank
    return 0 unless respond_to?(:score)

    (100.0 / (1.0 + Math::E ** (-0.03 * (score - 100)))).floor
  end
end
