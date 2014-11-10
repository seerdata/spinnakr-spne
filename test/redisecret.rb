require 'redis'

class RedisSecret

  REDIS_OPTIONS = {
    #'host' => '10.0.1.39'
    'host' => 'localhost'
  }

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_admin = 13
    @secret_token = '57ffa057-1878-46ea-9450-34475347e0f5'
  end

  def create_secret
    @redisc.select @db_admin
    hmap = @redisc.hgetall(@secretoken)
    if hmap.empty? == true
      puts 'secret token does not exist creating a new one'
      @redisc.hset @secret_token, 'secret', 'ashland'
    end
  end
end

rs = RedisSecret.new
rs.create_secret
