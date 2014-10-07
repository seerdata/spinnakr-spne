require 'json'
require_relative './redis/redisevent'
require_relative './redis/tokentransform'

module GenericManager

  def handle_generic_event(json)
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
