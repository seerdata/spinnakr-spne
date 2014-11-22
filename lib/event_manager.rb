require 'json'
require 'json-schema'
require_relative './redis/redisdata'
require_relative './redis/redisevent'
require_relative './redis/redistoken'
require_relative './redis/tokentransform'

module EventManager

  def get_request_data
    request.body.rewind
    data = JSON.parse request.body.read
  end

  def validate_json()
    rdata = get_request_data
    flag = true
    schema = File.join(File.dirname(__FILE__),"./redis/customer_schema.json")
    errors = JSON::Validator.fully_validate(schema, rdata, :strict => true)
    print 'validate_json errors = ', errors; puts
    if errors.size > 0
      flag = false
    end
    flag
  end

  def authenticate_post()
    hmap = get_request_data
    flag = false
    rt = RedisToken.new
    apkey = rt.get_apkey_from_uuid(hmap['access_token'])
    if apkey != nil
      flag = true
    end
    flag
  end

  def handle_generic_event()
    cmessage = get_request_data
    t = Transform.new
    tmessage = t.transform_customer_token(cmessage)
    RabbitMQ.publish_message(tmessage, "test.spnee.generic")
  end

  def handle_rec_event(dbnumber,project,dimension,key)
    redisevent = RedisEvent.new
    #print dbnumber + ' ' + project + ' ' + dimension + ' ' + key; puts
    redisevent.get_json(dbnumber,project,dimension,key)
  end

  def handle_data_event(dbnumber,project,dimension,key,calculation,interval)
    redisdata = RedisData.new
    print dbnumber + ' ' + project + ' ' + dimension + ' ' + key + ' '
    print calculation + ' ' + interval; puts
    redisdata.get_json(dbnumber,project,dimension,key,calculation,interval)
  end

end
