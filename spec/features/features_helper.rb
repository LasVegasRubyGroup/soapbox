require 'spec_helper'
require 'capybara/rspec'

# ENV["RAILS_ENV"] = 'capybara'

Capybara.asset_host = "http://localhost:3000"

# this is the transactional fix used by Jose Valim (and others) so
# DatabaseCleaner isn't necessary
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|
  config.include OmniauthHelpers
end
