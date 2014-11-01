# load rails and other dependencies
#
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

# spree test helpers
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'

# load supporting code
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# configure rspec
RSpec.configure do |config|
  config.order = 'random'

  # controller test setup
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Devise::TestHelpers, type: :controller
  
  # mocks
  config.mock_with :rspec
end
