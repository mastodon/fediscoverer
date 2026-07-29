class HashtagTrendsController < ApplicationController
  def index
    @trending_hashtags = Hashtag.ranked_trending(limit: 100)
  end
end
