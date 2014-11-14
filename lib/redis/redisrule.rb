require 'redis'
require_relative './redistoken'

class RedisRule

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @rt = RedisToken.new
    @key_primary_key = 'rules-primary-key'

    #@db_uuid = 10
    #@db_ap = 11
    #@db_dbnumber = 12
    #@db_admin = 13
    #@db_start = 100
    #@key_db_next = 'nextdb'
    #@key_db_mapping = 'hm:accountid:db'
  end

  def get_primary_key(dbnumber)
    @redisc.select dbnumber
    @redisc.incr @key_primary_key
    @redisc.get @key_primary_key
  end

  def build_rule_key(project,eventype,primarykey)
    "hash:" + project + ":" + eventype + ":rule:" + primarykey
  end

  def set_rule_key(rulekey,dbnumber,hmap)
    @redisc.select dbnumber
    hmap.each do |key|
      #print key; puts
      if key[0] != 'account' && key[0] != 'project'
        @redisc.hset rulekey, key[0], key[1]
      end
    end
  end

  def process_comparator(hmap)
    account = hmap['account']
    project = hmap['project']
    dbnumber = @rt.getDbNumber_from_accountid(account)
    primarykey = get_primary_key(dbnumber)
    rulekey = build_rule_key(project,'comparator',primarykey)
    print 'account = ', account, ' project = ', project
    print ' dbnumber = ', dbnumber
    print ' primary key = ', primarykey
    print ' ', rulekey; puts
    set_rule_key(rulekey,dbnumber,hmap)
  end

  def process_observer(hmap)
    account = hmap['account']
    project = hmap['project']
    dbnumber = @rt.getDbNumber_from_accountid(account)
    primarykey = get_primary_key(dbnumber)
    rulekey = build_rule_key(project,'observer',primarykey)
    print 'account = ', account, ' project = ', project
    print ' dbnumber = ', dbnumber
    print ' primary key = ', primarykey
    print ' ', rulekey; puts
    set_rule_key(rulekey,dbnumber,hmap)
  end


end
