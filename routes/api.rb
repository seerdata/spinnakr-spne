require 'warden'
require_relative './../lib/generic_manager'

# Spnee API
class Spnee < Sinatra::Base

  include GenericManager

  get '/' do
    content_type :json
    JSON::generate({ message: "Hello Sds" })
  end

  get '/api' do
    redirect "http://spinnakr.com/api"
  end

  post '/api/1.0/event' do
    if(!validate_json)
      return(JSON::generate({ message: "Sorry, the JSON document is not in the proper form." }))
    end
    if(!authenticate_post)
      return(JSON::generate({ message: "Sorry, this request can not be authenticated." }))
    end
    handle_generic_event
    JSON::generate({ message: "Thanks for your data." })
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

  get '/api/1.0/event/:dimension/:key' do
    env['warden'].authenticate!(:access_token)
    newuser = env['warden'].user
    dbnumber = newuser['dbnumber']
    project = newuser['project']
    handle_rec_event(dbnumber,project,params[:dimension],params[:key])
  end
end
