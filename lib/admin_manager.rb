require 'json'
require_relative './redis/redistoken'

module AdminManager

  def authenticate_admin_post()
    flag = false
    hmap = JSON.parse(params[:data])
    rt = RedisToken.new
    access_token = hmap['access_token']
    valid = rt.authenticate_admin(access_token)
    if valid == true
      flag = true
    end
    flag
  end

  def handle_admin_token()
    hmap = JSON.parse(params[:data])
    print hmap; puts
    rt = RedisToken.new
    token = hmap['token']
    account = hmap['account']
    project = hmap['project']
    rt.create_uuid_account_project(token, account, project)
  end

  def handle_admin_account()
    hmap = JSON.parse(params[:data])
    print hmap; puts
    rt = RedisToken.new
    account = hmap['account']
    project = hmap['project']
    rt.create_uuid_from_apkey(account, project)
  end

end
