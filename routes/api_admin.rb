require_relative './../lib/admin_manager'

# Spnee API
class Spnee < Sinatra::Base

  include AdminManager

  post '/api/1.0/admin/token' do
=begin
    if(!authenticate_admin_post)
      return(JSON::generate({ message: "Sorry, this admin request can not be authenticated." }))
    end
=end
    handle_admin_token
    JSON::generate({ message: "Thanks for your admin token data." })
  end

end
