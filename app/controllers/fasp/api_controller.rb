class Fasp::ApiController < ActionController::Base
  include FaspBase::ApiAuthentication

  skip_forgery_protection

  private

  def trend_params
    {
      hours: params[:withinLastHours].presence || 24,
      limit: params[:maxCount].presence || 20,
      language: params[:language].presence
    }
  end
end
