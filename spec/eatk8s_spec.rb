require 'spec_helper'
 
describe 'the eatk8s app' do

    before(:all) do
        @grocer = Grocer.new
        @shopper = Shopper.new
        @shopping_lists = {}
    end

    it "has a shopping list in the database" do
        @shopper.shop
        @shopping_lists = @grocer.get_active_shopping_lists
        expect(@shopping_lists.empty?).to eq false
    end

    def app
        Sinatra::Application
    end

    it "shops" do
        get '/shop'
        expect(last_response).to be_ok
    end

    it "process deliveries" do
        get '/whois'
        result = JSON.parse(last_response.body)
        result.each do |key, value|
            params = {'shopping_list' => key}
            post '/deliver', params
        end
        expect(@shopping_lists.empty?).to eq true
    end

end