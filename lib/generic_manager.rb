require 'json'
require_relative './redis/redisevent'

module GenericManager

  def handle_generic_event(siteid,json)
    message = JSON.parse(params[:data])
    siteid = params[:siteid]
    print siteid, ' ', message; puts
    RabbitMQ.publish_message(message, "test.spnee.event")
  end

  def handle_rec_event(project,dimension,key)
    redisevent = RedisEvent.new
    print project + ' ' + dimension + ' ' + key; puts
    redisevent.get_key(project,dimension,key)
  end

end
