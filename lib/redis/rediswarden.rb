require 'redis'
require 'securerandom'
require_relative './redisoptions'

class RedisWarden

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_zero = 0
    @db_uuid = 10
    @db_ap = 11
    @db_start = 100
    @key_db_next = 'nextdb'
    @key_db_mapping = 'hm:accountid:db'
  end

  def get_hash_from_apkey(apkey)
    myhash = {}
    myarray = apkey.split(':')
    myhash[:account] = myarray[0]
    myhash[:project] = myarray[1]
    myhash
  end

  def get_apkey_from_account_project(account, project)
    key = account.to_s + ':' + project.to_s
  end

  def get_uuid_from_apkey(account, project)
    apkey = get_apkey_from_account_project account, project
    @redisc.select @db_ap
    uuid = @redisc.hget(apkey,'uuid')
    if uuid == nil
      puts 'account project key does not exist, creating a new uuid'
      uuid = SecureRandom.uuid
      @redisc.select @db_uuid
      @redisc.hset uuid, 'account', account.to_s
      @redisc.hset uuid, 'project', project.to_s
      @redisc.select @db_ap
      @redisc.hset apkey, 'uuid', uuid
      getDbNumber_from_accountid(account.to_s)
      @redisc.select @db_zero
    end
    uuid
  end

  def get_apkey_from_uuid(uuid)
    apkey = nil
    @redisc.select @db_uuid
    account = @redisc.hget uuid, 'account'
    project = @redisc.hget uuid, 'project'
    if account != nil && project != nil
      apkey = get_apkey_from_account_project(account, project)
    end
    apkey
  end

  def delete_uuid(uuid)
    @redisc.select @db_uuid
    account = @redisc.hget uuid, 'account'
    project = @redisc.hget uuid, 'project'
    if account != nil && project != nil
      apkey = get_apkey_from_account_project(account, project)
      @redisc.del uuid
      @redisc.select @db_ap
      @redisc.del apkey
    end
  end

  def delete_apkey(account,project)
    apkey = get_apkey_from_account_project account, project
    @redisc.select @db_ap
    uuid = @redisc.hget(apkey,'uuid')
    if uuid != nil
      @redisc.del apkey
      @redisc.select @db_uuid
      @redisc.del uuid
    end
  end

  def getDbNumber_from_accountid(account)
    @redisc.select @db_ap
    db_number = @redisc.hget(@key_db_mapping,account)
    if db_number == nil
      print 'db_number does not exist'; puts
      nextdb = @redisc.get @key_db_next
      if nextdb == nil
        print 'nextdb does not exist'; puts
        db_number = @db_start
        next_db_number = @db_start + 1
        @redisc.set(@key_db_next, next_db_number)
      else
        db_number = nextdb.to_i
        next_db_number = nextdb.to_i + 1
        @redisc.set(@key_db_next, next_db_number)
      end
      @redisc.hset(@key_db_mapping,account,db_number.to_s)
    end
    db_number
  end

end

=begin
rw = RedisWarden.new
db_number = rw.getDbNumber_from_accountid('3')
print 'db_number = ', db_number; puts
=end

=begin
rw = RedisWarden.new
uuid11 = rw.get_uuid_from_apkey('1','1')
puts uuid11
uuid21 = rw.get_uuid_from_apkey('2','1')
puts uuid21
apkey11 = rw.get_apkey_from_uuid(uuid11)
puts apkey11
apkey21 = rw.get_apkey_from_uuid(uuid21)
puts apkey21
hash11 = rw.get_hash_from_apkey(apkey11)
puts hash11
hash21 = rw.get_hash_from_apkey(apkey21)
puts hash21
=end

=begin
# Test Deleting Keys

rw.delete_uuid(uuid11)
rw.delete_apkey('2','1')
=end
