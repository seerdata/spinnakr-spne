require 'rest_client'


#RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

#RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

#RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

#RestClient.post "http://localhost:4567/test01", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

jdata = {:key => 'I am a tomato'}.to_json
response = RestClient.post 'http://localhost:4567/solve', :data => jdata, :content_type => :json, :accept => :json
