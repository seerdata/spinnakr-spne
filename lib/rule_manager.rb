require 'json'
require_relative './redis/redisrule'

module RuleManager

  def handle_rule_comparator()
    hmap = JSON.parse(params[:data])
    #print hmap; puts
    rr = RedisRule.new
    rr.process_comparator(hmap)
  end

  def handle_rule_observer()
    hmap = JSON.parse(params[:data])
    rr = RedisRule.new
    rr.process_observer(hmap)
  end

end
