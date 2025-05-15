class Fasp::FollowRecommendation::V0::AccountsController < Fasp::ApiController
  def index
    @follow_recommendation = FollowRecommendation.for(params[:actorUri], language: params[:language])

    render json: @follow_recommendation
  end
end
