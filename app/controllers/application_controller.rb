class ApplicationController < ActionController::Base
  include FaspBase::Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  default_form_builder FaspBase::FormBuilder
end
