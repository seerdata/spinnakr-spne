require 'warden'
require_relative './../lib/generic_manager'

# Spnee API
class Spneg < Sinatra::Base

  include GenericManager

  get '/' do
    content_type :json
    JSON::generate({ message: "Hello Sds" })
  end

  get '/api' do
    redirect "http://spinnakr.com/api"
  end

  post '/api/1.0/event/:siteid' do
    handle_generic_event(params[:siteid],params[:data])
  end

  # This is the protected route, without the proper access token you'll be redirected.
  get '/protected' do
      env['warden'].authenticate!(:access_token)

      content_type :json
      JSON::generate({ message: "This is an authenticated request!" })
  end

  # This is the route that unauthorized requests gets redirected to.
  post '/unauthenticated' do
      content_type :json
      JSON::generate({ message: "Sorry, this request can not be authenticated. Try again." })
  end

  # These API calls are for the recs / answers

  get '/api/1.0/event/:project/:dimension/:key' do
    handle_rec_event(params[:project],params[:dimension],params[:key])
  end
end
