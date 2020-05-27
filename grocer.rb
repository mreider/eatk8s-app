require 'sidekiq'
require 'sidekiq-status'
require 'active_support'
require 'active_support/time'

redis_host = ENV['REDIS_HOST'] || "localhost"
redis_port = ENV['REDIS_PORT'] || "6379"

Sidekiq.configure_server do |config|
    config.redis = {host: redis_host, port: redis_port, db: 0}
    Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes
    # accepts :expiration (optional)
    Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq.configure_client do |config|
    config.redis = {host: redis_host, port: redis_port, db: 0}
    Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

class Grocer
    include Sidekiq::Worker
    include Sidekiq::Status::Worker

    def perform(shopping_list,shopper,complexity=1)
        sleep complexity
    end

end


shopper_host = ENV['SHOPPER_HOST'] || "localhost"
shopper_port = ENV['SHOPPER_PORT'] || "4567"
grocer_host = ENV['GROCER_HOST'] || "localhost"
grocer_port = ENV['GROCER_PORT'] || "4567"

