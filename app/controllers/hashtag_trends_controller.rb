class HashtagTrendsController < ApplicationController
  def index
    @trending_hashtags = Hashtag.trending(limit: 100)
  end
end
