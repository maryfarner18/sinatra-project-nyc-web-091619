class VisitsController < ApplicationController

    get '/visits' do
       
    end

    post '/visits' do
  
        Visit.find_or_create_by(restaurant_id: params["restaurant_id"].to_i, user_id: params["user_id"].to_i)

        redirect "/restaurants/#{params["restaurant_id"].to_i}"
    end

end