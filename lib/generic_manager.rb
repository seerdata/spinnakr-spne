require 'json'

module GenericManager

  def handle_generic_visit(siteid,json)
    jdata = JSON.parse(params[:data])
    siteid = params[:siteid]
    print siteid, ' ', jdata; puts
    RabbitMQ.publish_message_trident jdata
  end

end
