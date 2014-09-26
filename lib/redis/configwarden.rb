require 'sinatra/base'
require 'warden'
require_relative './redistoken'

class Spneg < Sinatra::Base

# Configure Warden
use Warden::Manager do |config|
    config.scope_defaults :default,
    # Set your authorization strategy
    strategies: [:access_token],
    # Route to redirect to when warden.authenticate! returns a false answer.
    action: '/unauthenticated'
    config.failure_app = self
end

Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
end

# Implement your Warden stratagey to validate and authorize the access_token.
Warden::Strategies.add(:access_token) do
    def valid?
        # Validate that the access token is properly formatted.
        # Currently only checks that it's actually a string.
        request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
    end

    def authenticate!
        access_granted = false
        mytoken_uuid = request.env["HTTP_ACCESS_TOKEN"]
        rw = RedisToken.new
        apkey = rw.get_apkey_from_uuid(mytoken_uuid)
        if apkey != nil
          access_granted = true
          newuser = Hash.new
          newuser['uuid'] = mytoken_uuid
          myarray = apkey.split(':')
          newuser['account'] = myarray[0]
          newuser['project'] = myarray[1]
          dbnumber = rw.getDbNumber_from_accountid(myarray[0])
          newuser['dbnumber'] = dbnumber
        end
        !access_granted ? fail!("Could not log in") : success!(newuser)
    end
end

end
