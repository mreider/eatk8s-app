require "redis"

class Grocer
    attr_accessor :redis, :shopping_list, :shopper_name

    def initialize()
        @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: 0)
    end

    def deliver(shopping_list)
        shopper_name = @redis.get(shopping_list)
        @redis.del(shopping_list)
        return true
    end

    def get_active_shopping_lists()
        shopping_lists = @redis.keys
        active_shopping_lists = {}
        shopping_lists.each do |shopping_list|
            active_shopper = @redis.get(shopping_list)
            active_shopping_lists[shopping_list] = active_shopper
        end
        return active_shopping_lists
    end

end