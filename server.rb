require 'sinatra'
require 'erb'
require 'json'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq-status'
require 'redis'
require 'pry'
require_relative 'shopper'
require_relative 'grocer'
 

@@redis_host = ENV['REDIS_HOST'] || "localhost"
@@redis_port = ENV['REDIS_PORT'] || "6379"
@@shopper_host = ENV['SHOPPER_HOST'] || "localhost"
@@shopper_port = ENV['SHOPPER_PORT'] || "4567"

@@redis = Redis.new(host: @@redis_host, port: @@redis_port, db: 0)
@@shopper = Shopper.new

# These routes runs in three different ruby microservices
# but I kept all the routes on the same page and in the same codebase
# for simplicity and so I could test in localhost as if it's all one app
# on my laptop.
# 
# You can see in the /kubernetes folder how the host / port variables
# change based on what you're deploying. But it's all the same app,
# it just takes on different identities :)
# 
# The /, /shop, and /whois routes are for the frontend.
# The /purchase route is for the shopper microservice
# The /deliver route is for the grocer microservice
#
# Peace be with you.
#
# - Matt

get '/' do
    erb :index
end


get '/shop' do
    indecision = params[:indecision] || 2000
    complexity = params[:complexity] || 4
    uri = 'http://' + @@shopper_host + ":" + @@shopper_port + '/purchase'
        options = {
            body: {
                :indecision => indecision.to_i, # your columns/data
                :complexity => complexity.to_i
            }
        }
        
    job_id = HTTParty.post(uri, options).delete('"\\')
    #binding.pry
    data = Sidekiq::Status::get_all job_id
    args = JSON.parse(data['args'])
    shopping_list = args[0]
    shopper_name = args[1]
    #binding.pry
    shopping_info = {}
    shopping_info[shopping_list] = shopper_name
    return shopping_info.to_json
end

post '/deliver' do
    result = Grocer.perform_async(params['shopping_list'],params['shopper_name'],params['complexity'].to_i)
    #binding.pry
    return result.to_json
end

post '/purchase' do
    job_id = @@shopper.shop(params['indecision'],params['complexity'])
    #binding.pry
    return job_id.to_json
end

get '/whois' do
    keys = @@redis.keys("sidekiq*")
    shopping_lists = {}
    keys.each do |key|
        unless @@redis.hget(key,"status") == "complete" 
            shopping_list_string = @@redis.hget(key,"args").delete('\\"[]')
            shopping_list_array = shopping_list_string.split(",")
            fruits = shopping_list_array[0]
            shopper_name = shopping_list_array[1]
            shopping_lists[fruits] = shopper_name
        end
    end
    return shopping_lists.to_json
end


