Rails.application.configure do
  MissionControl::Jobs.base_controller_class = "FaspBase::Admin::BaseController"
  MissionControl::Jobs.http_basic_auth_enabled = false
end
