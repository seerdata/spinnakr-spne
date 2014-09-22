require 'redis'
require 'securerandom'
require_relative './redisoptions'

class RedisWarden

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_zero = 0
    @db_uuid = 10
    @db_ap = 11
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
end

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

# Test Deleting Keys

rw.delete_uuid(uuid11)
rw.delete_apkey('2','1')
