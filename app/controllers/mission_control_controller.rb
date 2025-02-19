# Base Controller adding custom authentication to mission control
class MissionControlController < ActionController::Base
  CREDENTIALS = {
    name: ENV["MISSION_CONTROL_USERNAME"],
    password: ENV["MISSION_CONTROL_PASSWORD"]
  }.freeze

  before_action :authenticate

  private

  def authenticate
    if authentication_enabled?
      http_basic_authenticate_or_request_with(**CREDENTIALS)
    else
      head :unauthorized
    end
  end

  def authentication_enabled?
    CREDENTIALS.values.all?(&:present?)
  end
end
