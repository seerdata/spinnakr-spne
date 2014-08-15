require 'sinatra/base'
require_relative 'lib/generic_manager'
require_relative 'lib/rabbitmq'

class Spneg < Sinatra::Base

  include GenericManager

  post '/generic/visit/:siteid' do
    handle_generic_visit(params[:siteid],params[:data])
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
