require 'rest_client'

response = RestClient.get 'http://localhost:4567', :content_type => :json, :accept => :json
puts response

response = RestClient.get 'http://localhost:4567/protected', :content_type => :json, :accept => :json, :access_token => '3d0b04b0-e422-4e93-a41b-49a699a1a9a2'
puts response

response = RestClient.get 'http://localhost:4567/protected', :content_type => :json, :accept => :json, :access_token => 'openxsesame'
puts response
