ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "minitest/mock"

require "webmock"
require "httpx/adapters/webmock"
require "webmock/minitest"
WebMock.disable_net_connect!(
  allow_localhost: true
)

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

module ActiveSupport
  class TestCase
    include MockObjects
    include Webmocks
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    self.fixture_paths << FaspBase::Engine.root.join("test/fixtures")
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest < ActiveSupport::TestCase
    include FaspBase::IntegrationTestHelper

    def sign_in
      post fasp_base.session_path, params: { email: "fediadmin@example.com", password: "super_secret" }
    end
  end
end
