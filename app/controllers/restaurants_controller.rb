require 'rack-flash' 
require "http"
require "optparse"

class RestaurantsController < ApplicationController

    use Rack::Flash
    
    get '/restaurants' do
        @restaurants = Restaurant.all
        @users = User.all
        erb :'restaurants/index'
    end
    
    get '/restaurants/new' do
        @restaurants = Restaurant.all

        erb :'/restaurants/new'
    end

    post '/restaurants' do

        #if we typed in a restaurant to add
        if params["restaurant"]
            @restaurant = Restaurant.new(params["restaurant"])
        
            if @restaurant.save
                flash[:message] = "Successfully created restaurant!"
                redirect "/restaurants/#{@restaurant.id}"
            else
                flash[:message] = "Restaurant needs a name!"
                redirect "/restaurants/new"
            end
        end

        #if we searched for restaurants to add
        if params["search"]
            @city = params["search"]["city"]
            @cuisine = params["search"]["cuisine"]

            #MAKE YELP REQUEST
           search_results = search(@cuisine, @city)
           restaurants = search_results["businesses"]
        
           #Create a restaurant for each search result
           restaurants.each do |restaurant|
                name = restaurant["name"]
                address = restaurant["location"]["display_address"][0]
                rating = restaurant["rating"]
                Restaurant.create(name: name, address: address, rating: rating)
           end
        
           redirect "/restaurants"
        end

    end

    get '/restaurants/:id' do
        @restaurant = Restaurant.find(params[:id])
        @users = User.all
        @my_users = @restaurant.users

        erb :'/restaurants/show'
    end

    get '/restaurants/:id/edit' do
        @restaurant = Restaurant.find(params[:id])
        
        erb :'/restaurants/edit'
    end

    patch '/restaurants/:id' do
        @restaurant = Restaurant.find(params[:id])

        if @restaurant.update(params["restaurant"])
            flash[:message] = "restaurant successfully updated!"
            redirect "/restaurants/#{@restaurant.id}"
        else 
            flash[:message] = "Restaurant needs a name!"
            redirect "/restaurants/#{@restaurant.id}/edit"
        end

    end

    delete '/restaurants/:id' do
        Restaurant.destroy(params[:id])

        redirect '/restaurants/'
    end

    def search(cusine, location)

        url = "https://api.yelp.com/v3/businesses/search"
        params = {
          term: cusine,
          location: location,
          limit: 20
        }
      
        response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
        response.parse
    end

end