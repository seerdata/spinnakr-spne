require 'rest_client'

jdata1 = {
  :email => 'michael@ashland.com',
  :message => 'todo bien tuesday'
}.to_json

response = RestClient.post 'http://localhost:3000/contact', :data => jdata1, :content_type => :json, :accept => :json
puts response
