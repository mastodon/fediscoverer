class Fasp::Trends::V0::LinksController < Fasp::ApiController
  def index
    trending_links = Link.includes(:recent_examples)
      .trending(**trend_params)

    render json: { links: trending_links.map { |l| { url: l.url, rank: l.rank, examples: l.recent_examples.map(&:uri) } } }
  end
end
