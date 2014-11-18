require 'json'
# Spnee API
class Spnee < Sinatra::Base

  post '/api/1.0/test1' do
    request.body.rewind
    data = JSON.parse request.body.read
    puts data
    puts data["red"]
    JSON::generate({ message: "Thanks for your test1 data." })
  end

  post '/api/1.0/test2' do
    request.body.rewind
    data = JSON.parse request.body.read
    puts data
    puts data["blue"]
    JSON::generate({ message: "Thanks for your test2 data." })
  end
end
