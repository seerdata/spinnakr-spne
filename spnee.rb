require 'sinatra'
require_relative './lib/generic_manager'

include GenericManager

set :server, 'thin'

post '/generic/visit/:siteid' do
  handle_generic_visit(params[:siteid],params[:data])
end
