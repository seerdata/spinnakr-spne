# https://github.com/stormasm/sds-warden/blob/rediswarden/doc/redisapi.md
# Tokens map to account and project
# Accounts map to Dbs
# You can have multiple projects in a DB, but not multiple accounts

require 'json'
require 'redis'
require_relative './redisoptions'

class RedisData

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
  end

  def build_hash_key(project,dimension,key,calculation,interval)
    "hash:" + project + ":" + dimension + ":" + key + ':' + calculation + ":" + interval
  end

  def get_data(db_number,project,dimension,key,calculation,interval)
    @redisc.select db_number
    hashkey = build_hash_key(project,dimension,key,calculation,interval)
    hmap = @redisc.hgetall(hashkey)
  end

  def get_json(db_number,project,dimension,key,calculation,interval)
    data = get_data(db_number,project,dimension,key,calculation,interval)
    json = JSON::generate(data)
  end
end

=begin
rd = RedisData.new
json = rd.get_json('100','2','job-skills','python','count','months')
print json; puts
=end
