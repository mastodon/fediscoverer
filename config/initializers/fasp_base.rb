FaspBase.tap do |f|
  # Replace with actual fasp name
  f.fasp_name = Rails.application.name

  # Domain of the fasp, used to generate URLs outside of a requests context
  f.domain = ENV["DOMAIN"] || ActionController::Base.default_url_options[:host] || "localhost:3000"

  # Add supported capabilities here:
  f.capabilities = [
    { id: "data_sharing", version: "0.1" },
    { id: "trends", version: "0.1" }
  ]

  # Additional metadata
  # f.privacy_policy_url = ENV["PRIVACY_POLICY_URL"]
  # f.privacy_policy_language = ENV["PRIVACY_POLICY_LANGUAGE"]
  # f.contact_email = ENV["CONTACT_EMAIL"]
  # f.fediverse_account = ENV["FEDIVERSE_ACCOUNT"]
end

# If you plan to patch classes from the `fasp_base` engine
# consider putting patches into their own module and
# add something like this:
#
# Rails.application.config.to_prepare do
#   FaspBase::Server.prepend FaspBase::ServerExtensions
# end
Rails.application.config.to_prepare do
  FaspBase::Server.prepend FaspBase::ServerExtensions
end
