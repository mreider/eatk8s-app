require "redis"

class Grocer
    attr_accessor :redis, :shopping_list, :shopper_name

    def initialize()
        @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: 0)
    end

    def deliver(shopping_list,complexity=1,size=1)
        shopper_name = @redis.get(shopping_list)
        @redis.del(shopping_list)
        calculate_things(complexity)
        grow_orders(size,shopping_list)
        return true
    end

    def calculate_things(complexity)
        complexity <= 2 ? 1 : fibonacci(complexity - 1) + fibonacci(complexity - 2)
        return true
    end

    def grow_order(size,shopping_list)
        size.times { a << shopping_list.to_s }
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