require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load
load './TwitterClient.rb'


get "/tweets/:user_name" do
  tc = TwitterClient.new
  user = tc.show_user_timeline(params[:user_name])
  "hello tree"
end
