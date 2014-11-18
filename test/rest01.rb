require 'rest_client'

#RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

#RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :'application/json'

#RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

#RestClient.post "http://localhost:4567/test01", { 'x' => 1 }.to_json, :content_type => :'application/json'

response = RestClient.get 'http://localhost:4567/api/1.0/event/job-skills/python', :content_type => :'application/json', :access_token => '27ffa057-1878-46ea-9450-34475347e0d2'
puts response

jdata = {:access_token => '104a5866-b844-4186-9322-19cacdcec298'}.to_json
response = RestClient.post 'http://localhost:4567/api/1.0/event', jdata, :content_type => :'application/json'
puts response

jdata = {:access_token => '104a5866-b844-4186-9322-19cacdcec297'}.to_json
response = RestClient.post 'http://localhost:4567/api/1.0/event', jdata, :content_type => :'application/json'
puts response
