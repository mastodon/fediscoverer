class Admin::FollowRecommendationPresetsController < FaspBase::Admin::BaseController
  def index
    @follow_recommendation_presets = Actor.recommended
  end

  def create
    if params[:uri].present?
      CreateFollowRecommendationPresetJob.perform_later(params[:uri])

      redirect_to admin_follow_recommendation_presets_path,
        notice: t(".success")
    else
      redirect_to admin_follow_recommendation_presets_path,
        alert: t(".uri_missing")
    end
  end

  def destroy
    actor = Actor.find(params[:id])
    actor.update!(recommended: false)

    redirect_to admin_follow_recommendation_presets_path,
      notice: t(".success")
  end
end
