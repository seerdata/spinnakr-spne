require 'redis'

class RedisRule

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_uuid = 10
    @db_ap = 11
    @db_dbnumber = 12
    @db_admin = 13
    @db_start = 100
    @key_db_next = 'nextdb'
    @key_db_mapping = 'hm:accountid:db'
  end

  def process_comparator(hmap)
    print hmap['account']; puts
    print hmap['operator']; puts
  end

  def process_observer(hmap)
    print hmap['account']; puts
    print hmap['trigger']; puts
  end
end
