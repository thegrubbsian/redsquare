module Commands
  module Keys

    def self.included(klass)
      redis = Redis.current

      klass.class_eval do

        get "/keys/(:pattern)" do
          redis.keys
        end

      end
    end

  end
end
