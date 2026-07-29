class LinkTrendsController < ApplicationController
  def index
    @trending_links = Link.ranked_trending(limit: 100)
  end
end
