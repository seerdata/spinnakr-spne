require 'json'
require 'json-schema'
require_relative './redis/redisevent'
require_relative './redis/redistoken'
require_relative './redis/tokentransform'

module GenericManager

  def validate_json()
    flag = true
    schema = File.join(File.dirname(__FILE__),"./redis/customer_schema.json")
    data = params[:data]
    errors = JSON::Validator.fully_validate(schema,data, :strict => true)
    print 'validate_json errors = ', errors; puts
    if errors.size > 0
      flag = false
    end
    flag
  end

  def authenticate_post()
    flag = false
    hmap = JSON.parse(params[:data])
    rt = RedisToken.new
    apkey = rt.get_apkey_from_uuid(hmap['access_token'])
    if apkey != nil
      flag = true
    end
    flag
  end

  def handle_generic_event()
    cmessage = JSON.parse(params[:data])
    #print cmessage; puts
    t = Transform.new
    tmessage = t.transform_customer_token(cmessage)
    RabbitMQ.publish_message(tmessage, "test.spnee.generic")
  end

  def handle_rec_event(dbnumber,project,dimension,key)
    redisevent = RedisEvent.new
    #print dbnumber + ' ' + project + ' ' + dimension + ' ' + key; puts
    redisevent.get_json(dbnumber,project,dimension,key)
  end

end
