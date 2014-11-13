require_relative './../lib/rule_manager'

# Spnee API
class Spnee < Sinatra::Base

  include AdminManager

  # this takes in a token, account, and project
  post '/api/1.0/rule/comparator' do
    handle_rule_comparator
    JSON::generate({ message: "Thanks for your rule comparator data." })
  end

  # this takes in an account and project and automatically creates a token
  post '/api/1.0/rule/observer' do
    handle_rule_observer
    JSON::generate({ message: "Thanks for your rule observer data." })
  end
end
