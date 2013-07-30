require "rubygems"
require "redsquare"
require "rack/test"
require "fakeredis/rspec"
require "pry"

set :environment, :test

RSpec.configure do |config|
  config.mock_with :rspec
end
