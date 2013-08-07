require "redsquare/version"
require "active_support/all"
require "sinatra"
require "redis"
require "json"
require "redsquare/config"
require "redsquare/app"

module Redsquare

  def configure
    Config
  end

end
