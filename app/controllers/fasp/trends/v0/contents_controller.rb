class Fasp::Trends::V0::ContentsController < Fasp::ApiController
  def index
    trending_content = ContentObject.trending(**trend_params)
    distribution = ContentActivity.distribution_of(trending_content, hours: trend_params[:hours])

    render json: { content: trending_content.map { |c| { uri: c.uri, rank: c.rank, distribution: distribution[c.id] } } }
  end
end
