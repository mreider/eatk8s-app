require "redis"
require "date"
require "pry"
require 'sidekiq'
require 'sidekiq-status'
require_relative 'grocer'
require 'httparty'

@@grocer_host = ENV['GROCER_HOST'] || "localhost"
@@grocer_port = ENV['GROCER_PORT'] || "4567"

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
        #binding.pry
        uri = 'http://' + @@grocer_host + ":" + @@grocer_port + '/deliver'
        options = {
            body: {
                :shopper_name => @shopper_name, # your columns/data
                :shopping_list => @shopping_list,
                :complexity => complexity
            }
        }
        job_id = HTTParty.post(uri, options)
        #binding.pry
        return job_id
    end

    def think(shopping_list,indecision)
        a = []
        i = indecision.to_i
        i.times { a.push(shopping_list.to_s) }
    end

end