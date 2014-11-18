require 'json'
require_relative './redis/redisrule'

module RuleManager

  def get_request_data
    request.body.rewind
    data = JSON.parse request.body.read
  end

  def handle_rule_comparator()
    hmap = get_request_data
    rr = RedisRule.new
    rr.process_comparator(hmap)
  end

  def handle_rule_observer()
    hmap = get_request_data
    rr = RedisRule.new
    rr.process_observer(hmap)
  end

end
