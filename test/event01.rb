require 'rest_client'

response = RestClient.get 'http://localhost:4567/api/1.0/event/1/job-skills/ios', :content_type => :json, :accept => :json, :access_token => 'aef7d66a-bf0d-4a1e-8c5f-ded77f036718'
puts response
