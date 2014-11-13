require 'json'
require_relative './redis/redistoken'

module RuleManager

  def handle_rule_comparator()
    hmap = JSON.parse(params[:data])
    print hmap; puts
    rt = RedisToken.new
    account = hmap['account']
    project = hmap['project']
    #rt.create_uuid_account_project(token, account, project)
  end

  def handle_rule_observer()
    hmap = JSON.parse(params[:data])
    print hmap; puts
    rt = RedisToken.new
    account = hmap['account']
    project = hmap['project']
    #rt.create_uuid_from_apkey(account, project)
  end

end
