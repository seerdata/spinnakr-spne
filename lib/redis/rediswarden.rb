require 'redis'
require 'securerandom'

REDIS_OPTIONS = {
 #'host' => '10.0.1.104'
 'host' => 'localhost'
}

class RedisWarden

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_zero = 0
    @db_uuid = 1
    @db_ap = 2
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

=begin
rw = RedisWarden.new
uuid12 = rw.get_uuid_from_apkey('1','2')
puts uuid12
uuid34 = rw.get_uuid_from_apkey('3','4')
puts uuid34
apkey12 = rw.get_apkey_from_uuid(uuid12)
puts apkey12
apkey34 = rw.get_apkey_from_uuid(uuid34)
puts apkey34
hash12 = rw.get_hash_from_apkey(apkey12)
puts hash12
hash34 = rw.get_hash_from_apkey(apkey34)
puts hash34

# Test Deleting Keys

rw.delete_uuid(uuid12)
rw.delete_apkey('3','4')
=end
