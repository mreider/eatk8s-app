require 'spec_helper'
require 'rspec'
require 'rack/test'
RSpec.configure do |config|
    config.include Rack::Test::Methods
    config.after(:all) do
        redis = Redis.new
        redis.flushdb
    end
end