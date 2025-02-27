class Fasp::Trends::V0::HashtagsController < Fasp::ApiController
  def index
    trending_hashtags = Hashtag.includes(:recent_examples)
      .trending(**trend_params)
    distribution = HashtagActivity.distribution_of(trending_hashtags, hours: trend_params[:hours], language: trend_params[:language])

    render json: { hashtags: trending_hashtags.map { |c| { name: c.name, rank: c.rank, distribution: distribution[c.id], examples: c.recent_examples.map(&:uri) } } }
  end
end
