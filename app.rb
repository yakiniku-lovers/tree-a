require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load
load './TwitterClient.rb'


get '/' do
  erb :index
end

get '/request' do
	params["name"]
end

get "/tweets/:user_name" do
  tc = TwitterClient.new
  tc.json_user_timeline(params[:user_name], 
    { count: 200, exclude_replies: true }
  )
end
