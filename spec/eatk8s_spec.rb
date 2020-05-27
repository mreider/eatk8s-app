require 'spec_helper'
 
describe 'the eatk8s app' do

    before(:all) do
        @shopper = Shopper.new
        @shopping_lists = {}
    end

    def app
        Sinatra::Application
    end

    it "shops" do
        get '/shop'
        expect(last_response).to be_ok
    end

    it "has orders" do
        get '/whois'
        result = JSON.parse(last_response.body)
        expect(last_response).to be_ok
    end

end