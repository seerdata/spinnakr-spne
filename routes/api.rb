require_relative './../lib/generic_manager'

# Spnee API
class Spneg < Sinatra::Base

  include GenericManager

  get '/api' do
    redirect "http://spinnakr.com/api"
  end

  post '/api/1.0/event/:siteid' do
    handle_generic_event(params[:siteid],params[:data])
  end
end
