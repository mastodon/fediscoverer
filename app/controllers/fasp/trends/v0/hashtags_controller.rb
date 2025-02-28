class Fasp::Trends::V0::HashtagsController < Fasp::ApiController
  def index
    trending_hashtags = Hashtag.includes(:recent_examples)
      .trending(**trend_params)

    render json: { hashtags: trending_hashtags.map { |c| { name: c.name, rank: c.rank, examples: c.recent_examples.map(&:uri) } } }
  end
end
