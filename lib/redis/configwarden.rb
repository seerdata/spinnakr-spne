require 'sinatra/base'
require 'warden'
require_relative './rediswarden'

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
        print 'token = ', mytoken_uuid; puts
        rw = RedisWarden.new
        apkey = rw.get_apkey_from_uuid(mytoken_uuid)
        print 'apkey = ', apkey; puts
        #access_granted = (request.env["HTTP_ACCESS_TOKEN"] == 'opensesame')
        if apkey != nil
          access_granted = true
        end
        !access_granted ? fail!("Could not log in") : success!(access_granted)
    end
end

end
