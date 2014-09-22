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
    # Eventually we will pass the token in here as well
    # so that we can use it to get the db_number
    db_number = redisevent.get_db_from_token
    print db_number + ' ' + project + ' ' + dimension + ' ' + key; puts
    redisevent.get_json(db_number,project,dimension,key)
  end

end
