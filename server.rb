require 'sinatra'
require 'erb'
require 'json'
require_relative 'shopper'
require_relative 'grocer'

get '/' do
    erb :index
end

get '/shop' do
    shopper = Shopper.new
    shopping_info = shopper.shop
    return shopping_info.to_json
end

post '/deliver' do
    grocer = Grocer.new 
    grocer.deliver(params['shopping_list'],params['complexity'].to_i,params['size'].to_i)
    return params['shopping_list'].to_json
end

get '/whois' do
    grocer = Grocer.new
    shopping_lists = grocer.get_active_shopping_lists()
    return shopping_lists.to_json
end

