require 'json'
require_relative './redis/redistoken'

module AdminManager

  def authenticate_admin_post()
    flag = false
    hmap = JSON.parse(params[:data])
    rt = RedisToken.new
    apkey = rt.get_apkey_from_uuid(hmap['access_token'])
    if apkey != nil
      flag = true
    end
    flag
  end

  def handle_admin_token()
    cmessage = JSON.parse(params[:data])
    print cmessage; puts
  end

end
