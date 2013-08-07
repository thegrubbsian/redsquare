module Redsquare
  module Config
    extend self

    def redis=(arg)
      if arg.is_a?(Redis)
        @redis = arg
      else
        @redis = Redis.new(arg)
      end
    end

    def redis
      @redis ||= Redis.current
    end

    def restricted_methods
      @restricted_methods || []
    end

    def restricted_methods=(methods)
      @restricted_methods = methods
    end

  end
end
