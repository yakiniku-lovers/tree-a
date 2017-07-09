require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load
load './TwitterClient.rb'

enable :sessions

before do
  @twitter = TwitterOAuth::Client.new(
    consumer_key: ENV['CONSUMER_KEY'],
    consumer_secret: ENV['CONSUMER_SECRET'],
    token: session[:access_token],
    secret: session[:secret_token]
  )
end

get '/request_token' do
  callback_url = "#{base_url}/access_token"
  request_token = @twitter.request_token(oauth_callback: callback_url)
  session[:request_token] = request_token.token
  session[:request_token_secret] = request_token.secret
  redirect request_token.authorize_url
end

get '/access_token' do
  begin
    @access_token = @twitter.authorize(
      session[:request_token],
      session[:request_token_secret],
      oauth_verifier: params[:oauth_verifier]
    )
  rescue OAuth::Unauthorized => @exception
    return erb :authorize_fail
  end

  session[:access_token] = @access_token.token
  session[:secret_token] = @access_token.secret
  session[:user_id] = @twitter.info['user_id']
  session[:screen_name] = @twitter.info['screen_name']
  session[:profile_image] = @twitter.info['profile_image_url_https']

  redirect '/'
end

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

def base_url
  default_port = (request.scheme == "http") ? 9292 : 443
  port = (request.port == default_port) ? ":9292" : ":#{request.port.to_s}"
  "#{request.scheme}://#{request.host}#{port}"
end