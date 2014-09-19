require 'json'

module GenericManager

  def handle_generic_event(siteid,json)
    message = JSON.parse(params[:data])
    siteid = params[:siteid]
    print siteid, ' ', message; puts
    RabbitMQ.publish_message(message, "test.spnee.event")
  end

  def handle_rec_event(project,dimension,key)
    print project + ' ' + dimension + ' ' + key; puts
  end

end
