require "bunny"
require "rest_client"
require_relative './../lib/redis/redistoken'


def transform_payload(input)
  hm = Hash.new
  rt = RedisToken.new
  data = JSON.parse(input)
  data.each do |key,value|
    if key == 'token_id'
      apkey = rt.get_apkey_from_uuid(value)
      account = rt.get_account_from_apkey(apkey)
      project = rt.get_project_from_apkey(apkey)
      dbnumber = rt.getDbNumber_from_accountid(account)
      print key, ' ', value, ' ', apkey, ' ', account, ' ', project, ' ', dbnumber; puts
      hm['account'] = account
      hm['project'] = project
      hm['dbnumber'] = dbnumber
    else
      hm[key] = value
     end
  end
  JSON.generate(hm)
end

connection = Bunny.new
connection.start

channel = connection.create_channel
q = channel.queue("customer", :durable => true, :auto_delete => false)

q.subscribe do |delivery_info, properties, payload|
  #puts "[consumer] #{q.name} received a message: #{payload}"
  transformedjson = transform_payload(payload)
  response = RestClient.post 'http://localhost:4567/api/1.0/event/151',
              :data => transformedjson, :content_type => :json, :accept => :json

end

sleep 3.5
puts "Disconnecting..."
connection.close
