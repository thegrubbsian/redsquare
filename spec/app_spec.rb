require "spec_helper"

describe Redsquare::App do
  include Rack::Test::Methods

  def app
    Redsquare::App
  end

  def result
    JSON.parse(last_response.body)["result"]
  end

  def redis
    Redis.current
  end

  describe "GET commands" do

    before do

      # String
      redis.set "string_a", "bar"
      redis.set "string_b", "baz"

      # Sets
      redis.sadd "set_a", "a"
      redis.sadd "set_a", "b"
      redis.sadd "set_a", "c"

      redis.sadd "set_b", "b"
      redis.sadd "set_b", "c"
      redis.sadd "set_b", "d"

      # Lists
      redis.rpush "list_a", "a"
      redis.rpush "list_a", "b"
      redis.rpush "list_a", "c"

      redis.rpush "list_b", "b"
      redis.rpush "list_b", "c"
      redis.rpush "list_b", "d"

      # Expiring key
      redis.set "expire", "foo"
      redis.expireat "expireat", 1555555555005

      # Hashes
      redis.hset "hash_a", "a", 1
      redis.hset "hash_a", "b", 2.00
      redis.hset "hash_a", "c", "foobar"
    end

    describe "returns the correct response for" do

      it "sinter" do
        get "/sinter/set_a/set_b"
        expect(result).to eq ["b", "c"]
      end

      it "sdiff" do
        get "/sdiff/set_a/set_b"
        expect(result).to eq ["a"]
        get "/sdiff/set_b/set_a"
        expect(result).to eq ["d"]
      end

      it "scard" do
        get "/scard/set_a"
        expect(result).to eq 3
      end

      it "randomkey" do
        get "/randomkey"
        expect(result).to_not be_nil
      end

      it "mget" do
        get "/mget/string_a/string_b"
        expect(result).to eq ["bar", "baz"]
      end

      it "lrange" do
        get "/lrange/list_a/0/1"
        expect(result).to eq ["a", "b"]
      end

      it "llen" do
        get "/llen/list_a"
        expect(result).to eq 3
      end

      it "lindex" do
        get "/lindex/list_a/1"
        expect(result).to eq "b"
      end

      it "keys" do
        get "/keys"
        expect(result).to eq Redis.current.keys
      end

      it "hvals" do
        get "/hvals/hash_a"
        expect(result).to eq ["1", "2.0", "foobar"]
      end

      it "hmget" do
        get "/hmget/hash_a/a/c"
        expect(result).to eq ["1", "foobar"]
      end

      it "hlen" do
        get "/hlen/hash_a"
        expect(result).to eq 3
      end

      it "hkeys" do
        get "/hkeys/hash_a"
        expect(result).to eq ["a", "b", "c"]
      end

      it "hgetall" do
        get "/hgetall/hash_a"
        expect(result).to eq({ "a" => "1", "b" => "2.0", "c" => "foobar" })
      end

      it "hget" do
        get "/hget/hash_a/a"
        expect(result).to eq "1"
      end

      it "hexists" do
        get "/hexists/hash_a/c"
        expect(result).to be_true
      end

      it "getrange" do
        get "/getrange/string_a/0/1"
        expect(result).to eq "ba"
      end

      it "get" do
        get "/get/string_a"
        expect(result).to eq "bar"
      end

      it "exists" do
        get "/get/string_a"
        expect(result).to be_true
      end

      it "dbsize" do
        get "/dbsize"
        expect(result).to eq 8
      end

    end

  end

  describe "POST commands" do

    describe "returns the correct response for" do

      it "setrange" do
        redis.set "string_a", "Hello World"
        post "/setrange", args: ["string_a", 6, "Redis"]
        expect(redis.get "string_a").to eq "Hello Redis"
      end

      it "setnx" do
        post "/setnx", args: ["bar", "baz"]
        expect(redis.get "bar").to eq "baz"
      end

      it "set" do
        post "/set", args: ["string_a", "foo"]
        expect(redis.get "string_a").to eq "foo"
      end

      it "sdiffstore" do
        redis.sadd "list_a", "a"
        redis.sadd "list_a", "b"
        redis.sadd "list_a", "c"
        redis.sadd "list_b", "b"
        redis.sadd "list_b", "c"
        redis.sadd "list_b", "d"
        post "/sdiffstore", args: ["list_c", "list_a", "list_b"]
        expect(redis.smembers "list_c").to eq ["a"]
      end

    end

  end

  describe "config" do

    describe "restricted_methods" do

      it "prevents the method from being exposed" do
        Redsquare::Config.restricted_methods = [:keys]
        post "/keys"
        expect(last_response.status).to eq 404
      end

    end

  end

end
