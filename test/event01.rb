require 'rest_client'

# DB 100, project 1
response = RestClient.get 'http://localhost:4567/api/1.0/event/1/job-skills/python', :content_type => :json, :accept => :json, :access_token => '104a5866-b844-4186-9322-59cacdcec297'
puts response

puts

# DB 100, project 2
response = RestClient.get 'http://localhost:4567/api/1.0/event/2/job-skills/ruby', :content_type => :json, :accept => :json, :access_token => '25f32255-aaeb-4d2f-8988-26494bc4d58d'
puts response

puts

# DB 101, project 1
response = RestClient.get 'http://localhost:4567/api/1.0/event/1/job-skills/android', :content_type => :json, :accept => :json, :access_token => '3c953ea8-a620-45bf-8959-6feee5d57c33'
puts response
