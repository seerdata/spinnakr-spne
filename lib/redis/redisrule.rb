require 'redis'
require_relative './redistoken'

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
    @rt = RedisToken.new
  end

  def process_comparator(hmap)
    account = hmap['account']
    project = hmap['project']
    dbnumber = @rt.getDbNumber_from_accountid(account)
    print 'RedisRule: processing comparator '
    print 'account = ', account, ' project = ', project
    print ' dbnumber = ', dbnumber; puts
    account = hmap['account']
    print 'operator = ', hmap['operator']; puts
  end

  def process_observer(hmap)
    account = hmap['account']
    project = hmap['project']
    dbnumber = @rt.getDbNumber_from_accountid(account)
    print 'RedisRule: processing observer '
    print 'account = ', account, ' project = ', project
    print ' dbnumber = ', dbnumber; puts
    print 'trigger = ', hmap['trigger']; puts
  end
end
