require 'sinatra'
require 'json'
set :server, 'thin'

post '/generic/visit/:siteid' do
  jdata = JSON.parse(params[:data])
  siteid = params[:siteid]
  print siteid, ' ', jdata; puts
end
