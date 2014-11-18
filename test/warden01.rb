require 'rest_client'

response = RestClient.get 'http://localhost:4567', :content_type => :'application/json'
puts response

response = RestClient.get 'http://localhost:4567/protected', :content_type => :'application/json', :access_token => '695f386c-cf12-40b4-9edb-7fa7732c14f0'
puts response

response = RestClient.get 'http://localhost:4567/protected', :content_type => :'application/json', :access_token => 'openxsesame'
puts response
