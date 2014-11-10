require 'redis'
require 'securerandom'
require_relative './redisoptions'

class RedisToken

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

  def get_hash_from_apkey(apkey)
    myhash = {}
    myarray = apkey.split(':')
    myhash[:account] = myarray[0]
    myhash[:project] = myarray[1]
    myhash
  end

  def get_account_from_apkey(apkey)
    myhash = {}
    myarray = apkey.split(':')
    myarray[0]
  end

  def get_project_from_apkey(apkey)
    myhash = {}
    myarray = apkey.split(':')
    myarray[1]
  end

  def get_apkey_from_account_project(account, project)
    key = account.to_s + ':' + project.to_s
  end

  def create_uuid_from_apkey(account, project)
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
      createDbNumber_from_accountid(account.to_s)
    end
    uuid
  end

# This is mainly used for testing when you want to create
# a uuid, account and project
  def create_uuid_account_project(uuidin, account, project)
    apkey = get_apkey_from_account_project account, project
    @redisc.select @db_ap
    uuid = @redisc.hget(apkey,'uuid')
    if uuid == nil
      puts 'account project key does not exist, creating a new uuid'
      uuid = uuidin
      @redisc.select @db_uuid
      @redisc.hset uuid, 'account', account.to_s
      @redisc.hset uuid, 'project', project.to_s
      @redisc.select @db_ap
      @redisc.hset apkey, 'uuid', uuid
      createDbNumber_from_accountid(account.to_s)
    end
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
    @redisc.select @db_dbnumber
    db_number = @redisc.hget(@key_db_mapping,account)
  end

  def createDbNumber_from_accountid(account)
    @redisc.select @db_dbnumber
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

  def authenticate_admin(access_token)
    flag = false
    #print 'redistoken authenticate_admin ', access_token; puts
    @redisc.select @db_admin
    hmap = @redisc.hgetall(access_token)
    if hmap.empty? != true
      flag = true
      mytime = Time.now
      @redisc.hset(access_token,'timestamp',mytime)
    end
    flag
  end
end
