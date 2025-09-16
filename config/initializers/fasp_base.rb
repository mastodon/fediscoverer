FaspBase.tap do |f|
  # Replace with actual fasp name
  f.fasp_name = ENV.fetch("FASP_NAME", Rails.application.name)

  # Domain of the fasp, used to generate URLs outside of a requests context
  f.domain = ENV["DOMAIN"] || ActionController::Base.default_url_options[:host] || "localhost:3000"

  # Add supported capabilities here:
  f.capabilities = [
    { id: "account_search", version: "0.1" },
    { id: "data_sharing", version: "0.1" },
    { id: "follow_recommendation", version: "0.1" },
    { id: "trends", version: "0.1" }
  ]

  # Additional metadata
  f.privacy_policy_url = ENV.fetch("PRIVACY_POLICY_URL", nil)
  f.privacy_policy_language = ENV.fetch("PRIVACY_POLICY_LANGUAGE", nil)
  f.contact_email = ENV.fetch("CONTACT_EMAIL", nil)
  f.fediverse_account = ENV.fetch("FEDIVERSE_ACCOUNT", nil)
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
