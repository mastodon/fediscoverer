class LinkTrendsController < ApplicationController
  def index
    @trending_links = Link.trending(limit: 100)
  end
end
