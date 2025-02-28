class Fasp::Trends::V0::ContentsController < Fasp::ApiController
  def index
    trending_content = ContentObject.trending(**trend_params)

    render json: { content: trending_content.map { |c| { uri: c.uri, rank: c.rank } } }
  end
end
