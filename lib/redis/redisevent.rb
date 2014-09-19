require 'json'
require 'redis'

REDIS_OPTIONS = {
 #'host' => '10.0.1.39'
 'host' => 'localhost'
}

class RedisEvent

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_zero = 0
    @db_account = 5
  end

  def build_key(project,dimension,key)
    project + ":" + dimension + ":" + key
  end

  def get_key(project,dimension,key)
    @redisc.select @db_account
    key = build_key(project,dimension,key)
    hmap = @redisc.hgetall(key)
    json = JSON::generate(hmap)
  end


end

#rse = RedisEvent.new
#puts rse.get_key("1","job-skills","android")
