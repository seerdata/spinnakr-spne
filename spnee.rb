require 'amqp'
require 'sinatra/base'
require 'yaml'

require_relative 'lib/redis/configwarden'
require_relative 'lib/rabbitmq'
require_relative 'routes/api'
require_relative 'routes/api_admin'

class Spnee < Sinatra::Base

  get '/ping' do
    'pong'
  end

  error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].to_s
  end

  configure do
    @@config = YAML.load_file("config/#{Sinatra::Application.environment}.config.yml") rescue nil || {}
    if Sinatra::Application.environment.to_s == "development"
      Thread.new { EM.run }
    end
    RabbitMQ.setup @@config['rabbitmq']
  end

end
