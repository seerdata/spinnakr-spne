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
    rt = RedisToken.new
    token = cmessage['access_token']
    account = cmessage['account']
    project = cmessage['project']
    rt.create_uuid_account_project(token, account, project)
  end

  def handle_admin_account()
    cmessage = JSON.parse(params[:data])
    print cmessage; puts
    rt = RedisToken.new
    account = cmessage['account']
    project = cmessage['project']
    rt.create_uuid_from_apkey(account, project)
  end

end
