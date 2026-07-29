module RankableConcern
  extend ActiveSupport::Concern

  included do
    attr_accessor :rank
  end

  class_methods do
    # Rank score of a list of records. Assumes the first record
    # in the list has the highest score, which is the case for
    # calculated trends
    def rank(list)
      return if list.blank?

      max_score = list.first.score
      one_percent = max_score / 100.0

      list.each do |item|
        item.rank = (item.score / one_percent).ceil.to_i
      end
    end
  end
end
