require "redis"
require "date"
require "pry"
require 'sidekiq'
require 'sidekiq-status'
require_relative 'grocer'


redis_host = ENV['REDIS_HOST'] || "localhost"
redis_port = ENV['REDIS_PORT'] || "6379"

class Shopper
    attr_accessor :redis, :shopping_list, :shopper_name

    def shop(indecision,complexity)
        fruits = ["🍇","🍈","🍉","🍊","🍋","🍌","🍍","🥭","🍎","🍏","🍐","🍑","🍒","🍓","🥝"]
        shopping_list_array = Array.new
        shopping_list_array.push(fruits.sample(8))
        @shopping_list = shopping_list_array.join
        name_file = File.open "names.json"
        names = JSON.load name_file
        @shopper_name = names['names'].sample
        think(shopping_list,indecision)
        job_id = Grocer.perform_async(@shopping_list,@shopper_name,complexity)
        return job_id
    end

    def think(shopping_list,indecision)
        a = ""
        indecision.times { a << shopping_list.to_s }
    end

end