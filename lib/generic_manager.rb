require 'json'

module GenericManager

  def handle_generic_event(siteid,json)
    message = JSON.parse(params[:data])
    siteid = params[:siteid]
    print siteid, ' ', message; puts
    RabbitMQ.publish_message(message, "test.spnee.event")
  end

end
