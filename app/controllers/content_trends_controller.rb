class ContentTrendsController < ApplicationController
  def index
    @trending_content = ContentObject.ranked_trending(limit: 100)
  end
end
