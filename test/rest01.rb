require 'rest_client'

#RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

#RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

#RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

#RestClient.post "http://localhost:4567/test01", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

jdata = {:key => 'Hi from Corvallis'}.to_json
#response = RestClient.post 'http://localhost:4567/generic/visit/151', :data => jdata, :content_type => :json, :accept => :json
response = RestClient.post 'http://localhost:4567/api/1.0/event', :data => jdata, :content_type => :json, :accept => :json
puts response

response = RestClient.get 'http://localhost:4567/api/1.0/event/job-skills/ios', :content_type => :json, :accept => :json, :access_token => '35b010e6-3a0d-421c-9c25-354a7a1336ae'
puts response

jdata = {:key => 'Hi from Corvallis'}.to_json
#response = RestClient.post 'http://localhost:4567/generic/visit/151', :data => jdata, :content_type => :json, :accept => :json
response = RestClient.post 'http://localhost:4567/api/1.0/event', :data => jdata, :content_type => :json, :accept => :json, :access_token => 'hello-iris'
puts response
