class ContentTrendsController < ApplicationController
  def index
    @trending_content = ContentObject.trending(limit: 100)
  end
end
