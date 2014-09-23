# https://github.com/stormasm/sds-warden/blob/rediswarden/doc/redisapi.md
# Tokens map to account and project
# Accounts map to Dbs
# You can have multiple projects in a DB, but not multiple accounts

require 'json'
require 'redis'
require_relative './redisoptions'

class RedisEvent

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
  end

  def build_primary_key(project,dimension,key,primarykey)
    project + ":" + dimension + ":" + key + ':' + primarykey
  end

  def build_set_key(project,dimension,key)
    project + ":" + dimension + ":" + key + ":set"
  end

  def get_data(db_number,project,dimension,key)
    myary = []
    @redisc.select db_number
    keyset = build_set_key(project,dimension,key)
    primary_keys = @redisc.smembers keyset
    primary_keys.each do |primary_key|
      keyprimary = build_primary_key(project,dimension,key,primary_key)
      hmap = @redisc.hgetall(keyprimary)
      myary.push(hmap)
    end
    myary
  end

  def get_json(db_number,project,dimension,key)
    data = get_data(db_number,project,dimension,key)
    json = JSON::generate(data)
  end

end

=begin
rse = RedisEvent.new
json = rse.get_json('100','1','job-skills','ios')
print json; puts
=end
