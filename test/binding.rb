require 'rest_client'

jdata1 = {
  :email => 'michael@ashland.com',
  :message => 'todo bien tuesday'
}.to_json

response = RestClient.post 'http://localhost:3000/contact', jdata1, :content_type => :'application/json'
puts response
