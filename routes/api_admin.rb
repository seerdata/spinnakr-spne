require_relative './../lib/admin_manager'

# Spnee API
class Spnee < Sinatra::Base

  include AdminManager

  # this takes in a token, account, and project
  post '/api/1.0/admin/token' do
=begin
    if(!authenticate_admin_post)
      return(JSON::generate({ message: "Sorry, this admin request can not be authenticated." }))
    end
=end
    handle_admin_token
    JSON::generate({ message: "Thanks for your admin token data." })
  end

  # this takes in an account and project and automatically creates a token
  post '/api/1.0/admin/account' do
=begin
    if(!authenticate_admin_post)
      return(JSON::generate({ message: "Sorry, this admin request can not be authenticated." }))
    end
=end
    handle_admin_account
    JSON::generate({ message: "Thanks for your admin account data." })
  end


end
