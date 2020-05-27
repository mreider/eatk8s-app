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
 

redis_host = ENV['REDIS_HOST'] || "localhost"
redis_port = ENV['REDIS_PORT'] || "6379"
@redis = Redis.new(host: redis_host, port: redis_port, db: 15)

get '/' do
    erb :index
end

get '/shop' do
    shopper = Shopper.new
    indecision = params[:indecision] || 2000
    complexity = params[:complexity] || 4
    job_id = shopper.shop(indecision,complexity)
    data = Sidekiq::Status::get_all job_id
    args = JSON.parse(data['args'])
    shopping_list = args[0]
    shopper_name = args[1]
    #binding.pry
    shopping_info = {}
    shopping_info[shopping_list] = shopper_name
    return shopping_info.to_json
end

get '/whois' do
    shopping_lists = []
    @redis.get(queues )
    queue.each do |job|
        job_id = job.jid
        data = Sidekiq::Status::get_all job_id
        args = JSON.parse(data['args'])
        shopping_list = args[0]
        shopper_name = args[1]
        shopping_info = {}
        shopping_info[shopping_list] = shopper_name
        shopping_lists.push(shopping_info)
    end
    return shopping_lists.to_json
end


