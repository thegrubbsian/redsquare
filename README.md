# Redsquare

Redsquare provides an HTTP interface for Redis that can be launched as a
standalone Sinatra app or mounted within a Rails application.

## Installation

Add this line to your application's Gemfile:

    gem 'redsquare'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redsquare

## Setup

### Configuration

Redsquare config begins and ends with setting a connection to the Redis
instance you want to use.  If you specify none, then you'll get a
connection to localhost on the default Redis port.  If you want to
specify a connection, use the following:

```ruby
Redsquare.configure do |config|

  # set it to an existing connection
  config.redis = Redis.current

  # pass a config hash that will be passed to Redis.new
  config.redis = { :host => 'localhost', :port => 6379 }

end
```

### Standalone Server

Simply run Redsquare from the command line.

```
redsquare

redsquare ~/some/path/to/redsquare_config.rb
```

### Mounting Within a Rails App

In your `routes.rb` file simplye mount the `Redsquare::App` module.

```ruby
YourApp::Application.routes.draw do
  mount Redsquare::App => "/redis"
end
```

## Usage

Using Redsquare is very simple.  Commands are divided into two
categories, those you issue with an HTTP POST call and those you issue
with an HTTP GET call.  The examples below will be in JavaScript but you
can easily call Redsquare endpoints form anywhere.

### GET Commands

The following are the Redis commands which Redsquare knows about that
can be called with a GET request:

```
dbsize
exists
get
getbit
getrange
hexists
hget
hgetall
hkeys
hlen
hmget
hvals
keys
lindex
llen
lrange
mget
pttl
randomkey
scard
sdiff
sinter
sismember
smembers
srandmember
sunion
```

The URL format for GET commands is straightforward:

```
GET /<command>/<arg1>/<arg2>/<arg...>
```

Some examples:

```
GET /get/somekey
GET /keys
GET /hget/somekey/somefield
```

The return value is a simple JSON object:

```javascript
// GET /get/somekey
{ result: "foo" }

// GET /keys
{ result: ["somekey", "someotherkey"]

// GET /hget/somekey/somefield
{ result: "baz" }
```

### POST Commands

The following are the Redis commands which Redsquare knows about that
can be called with a POST request:

```
sunionstore
srem
spop
smove
setrange
setnx
setbit
set
sdiffstore
sadd
rpush
rpoplpush
rpop
renamex
rename
psetex
pexpireat
pexpire
persist
msetnx
mset
ltrim
lset
lrem
lpushx
lpush
lpop
linsert
incrbyfloat
incrby
incr
hsetnx
hset
hmset
hincrbyfloat
hincrby
hdel
getset
expireat
expire
del
decrby
decr
append
```

Because these are POST commands and the arguments may be more complex
types than simple strings the semantics of the request are slightly
different.  Each URL follows the same format:

```
POST /<command>
```

Arguments are supplied via the POST parameter `args` which is an array
of arguments in the order that they would be passed to the underlying
Redis method.  For example:

```javascript
// Sets the 'somefield' field of the hash at key 'somekey' to 42
$.post("/hset", { args: ["somekey", "somefield", 42] });

// Increments the key at 'somekey' by 12
$.post("/incrby", { args: ["somekey", 12] });
```

The return value for POST commands is the same for GET commands, a
simple JSON hash with a `results` key containing the serialized return
value of the Redis call.

## TODO:

* Not all of the Redis commands are currently supported.
* Add support for Redis pub/sub.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
