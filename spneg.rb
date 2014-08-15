require 'sinatra/base'
require_relative './lib/generic_manager'

class Spneg < Sinatra::Base

include GenericManager

post '/generic/visit/:siteid' do
  handle_generic_visit(params[:siteid],params[:data])
end

end
