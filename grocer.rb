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
        grow_order(size,shopping_list)
        return true
    end

    def calculate_things(n)
        return  n  if ( 0..1 ).include? n
        ( calculate_things( n - 1 ) + calculate_things( n - 2 ) )
    end

    def grow_order(size,shopping_list)
        a = ""
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