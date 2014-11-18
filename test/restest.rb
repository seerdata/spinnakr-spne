require 'rest_client'

response = RestClient.post 'http://localhost:4567/api/1.0/test1', { 'x' => 1 }.to_json, :content_type => :'application/json'
puts response

response = RestClient.post 'http://localhost:4567/api/1.0/test2', { 'x' => 2 }.to_json, :content_type => :'application/json'
puts response

mydata1 = {:red => 'sam'}.to_json
response = RestClient.post 'http://localhost:4567/api/1.0/test1', mydata1, :content_type => :'application/json'
puts response

mydata2 = {:blue => 'ralph'}.to_json
response = RestClient.post 'http://localhost:4567/api/1.0/test2', mydata2, :content_type => :'application/json'
puts response
