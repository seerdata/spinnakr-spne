require 'sinatra'
require 'json'
set :server, 'thin'
connections = []

post '/solve' do
  jdata = JSON.parse(params[:data])
  puts jdata
end
