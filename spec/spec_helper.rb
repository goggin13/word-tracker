# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include Capybara::DSL
  config.include Devise::TestHelpers, type: :controller
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end

def integration_login(user)
  visit new_user_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  page.should have_content "Signed in successfully."
end
