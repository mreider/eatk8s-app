require "redis"
require "date"
require "pry"


class Shopper
    attr_accessor :redis, :shopping_list, :shopper_name
    
    def initialize()
        @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: 0)
    end

    def shop(cycles)
        fruits = ["🍇","🍈","🍉","🍊","🍋","🍌","🍍","🥭","🍎","🍏","🍐","🍑","🍒","🍓","🥝"]
        shopping_list_array = Array.new
        shopping_list_array.push(fruits.sample(8))
        @shopping_list = shopping_list_array.join
        name_file = File.open "names.json"
        names = JSON.load name_file
        @shopper_name = names['names'].sample
        @redis.set(@shopping_list,@shopper_name)
        return_value = {}
        return_value[@shopping_list] = @shopper_name
        think(shopping_list,cycles)
        return return_value
    end

    def think(shopping_list,cycles)
        cycles.to_i
        sleep(1)
        a = ""
        cycles.times { a << shopping_list.to_s }
    end

end