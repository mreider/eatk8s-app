require './server'
set :bind, '0.0.0.0'
set :port, 4567 #set your port!
Sinatra::Application.run!