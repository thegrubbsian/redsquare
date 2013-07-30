module Redsquare
  class App < Sinatra::Base

    POST_COMMANDS = [
      :setrange,
      :setnx,
      :setbit,
      :set,
      :sdiffstore,
      :sadd,
      :rpush,
      :rpoplpush,
      :rpop,
      :renamex,
      :rename,
      :psetex,
      :pexpireat,
      :pexpire,
      :persist,
      :msetnx,
      :mset,
      :ltrim,
      :lset,
      :lrem,
      :lpushx,
      :lpush,
      :lpop,
      :linsert,
      :incrbyfloat,
      :incrby,
      :incr,
      :hsetnx,
      :hset,
      :hmset,
      :hincrbyfloat,
      :hincrby,
      :hdel,
      :getset,
      :expireat,
      :expire,
      :del,
      :decrby,
      :decr,
      :append
    ]

    GET_COMMANDS = [
      :sinter,
      :sdiff,
      :scard,
      :randomkey,
      :pttl,
      :mget,
      :lrange,
      :llen,
      :lindex,
      :keys,
      :hvals,
      :hmget,
      :hlen,
      :hkeys,
      :hgetall,
      :hget,
      :hexists,
      :getrange,
      :getbit,
      :get,
      :exists,
      :dbsize
    ]

    POST_COMMANDS.each do |command|
      post "/#{command}" do
        content_type :json
        args = params[:args].map { |a| try_to_i a }
        #require "pry"; binding.pry
        val = Redis.current.send command, *args
        { result: val }.to_json
      end
    end

    GET_COMMANDS.each do |command|
      get "/#{command}/?*" do
        content_type :json
        args = params[:splat][0].split("/").map { |a| try_to_i a }
        val = Redis.current.send command, *args
        { result: val }.to_json
      end
    end

    def try_to_i(str)
      is_int = str.to_i.to_s == str
      is_int ? str.to_i : str
    end

  end
end
