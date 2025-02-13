class Fasp::Trends::V0::LinksController < Fasp::ApiController
  def index
    trending_links = Link.includes(:recent_examples)
      .trending(**trend_params)
    distribution = LinkActivity.distribution_of(trending_links, hours: trend_params[:hours], language: trend_params[:language])

    render json: { link: trending_links.map { |l| { url: l.url, rank: l.rank, distribution: distribution[l.id], examples: l.recent_examples.map(&:uri) } } }
  end
end
