require 'rest_client'

jdata = {
  :access_token => '104a5866-b844-4186-9322-19cacdcec298',
  :token => '704a5866-b844-4186-9322-99cacdcec299',
  :account => '7',
  :project => '9'
}.to_json

response = RestClient.post 'http://localhost:4567/api/1.0/admin/token', :data => jdata, :content_type => :json, :accept => :json
puts response
