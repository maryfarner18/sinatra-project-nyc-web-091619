require 'rack-flash' 

class UsersController < ApplicationController

    use Rack::Flash
    
    get '/users' do
        @users = User.all

        erb :'users/index'
    end
    
    get '/users/new' do
        @users = User.all

        erb :'users/new'
    end

    post '/users' do
        @user = User.new(params["user"])
        if @user.save
            flash[:message] = "Successfully created user!"
            redirect "/users/#{@user.id}"
        else
            flash[:message] = "User needs a name!"
            redirect "/users/new"
        end
    end

    get '/users/:id' do
        @user = User.find(params[:id])
        @restaurants = @user.restaurants

        erb :'users/show'
    end

    get '/users/:id/edit' do
        @user = User.find(params[:id])
        
        erb :'users/edit'
    end

    patch '/users/:id' do
        @user = User.find(params[:id])

        if @user.update(params["user"])
            flash[:message] = "User successfully updated!"
            redirect "/users/#{@user.id}"
        else 
            flash[:message] = "User needs a name!"
            redirect "/users/#{@user.id}/edit"
        end
    end

    delete '/users/:id' do
        User.destroy(params[:id])

        redirect '/users/'
    end

end