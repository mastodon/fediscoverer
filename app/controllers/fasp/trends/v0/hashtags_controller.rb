class Fasp::Trends::V0::HashtagsController < Fasp::ApiController
  def index
    trending_hashtags = Hashtag.ranked_trending(**trend_params)

    render json: { hashtags: trending_hashtags.map { |c| { name: c.name, rank: c.rank, examples: c.recent_examples.map(&:uri) } } }
  end
end
