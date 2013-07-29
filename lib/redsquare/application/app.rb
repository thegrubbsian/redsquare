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
      :dump,
      :dbsize
    ]

    POST_COMMANDS.each do |command|
      post "/#{command}/?*" do
        content_type :json
        args = params[:splat].select { |a| a.present? }.compact
        val = Redis.current.send command, *args
        { result: val }.to_json
      end
    end

    GET_COMMANDS.each do |command|
      get "/#{command}/?*" do
        content_type :json
        args = params[:splat][0].split("/")
        val = Redis.current.send command, *args
        { result: val }.to_json
      end
    end

  end
end
