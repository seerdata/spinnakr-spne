require 'rest_client'

response = RestClient.get 'http://localhost:4567/api/1.0/event/1/job-skills/android'
puts response
