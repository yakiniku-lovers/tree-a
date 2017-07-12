# frozen_string_literal: true

require './setup.rb'

before do
  @twitter = TwitterOAuth::Client.new(
    consumer_key: ENV['CONSUMER_KEY'],
    consumer_secret: ENV['CONSUMER_SECRET'],
    token: session[:access_token],
    secret: session[:secret_token]
  )
end

get '/' do
  @user = User.find_by(name: session[:screen_name])
  erb :index
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
    return erb :index
  end

  session[:access_token] = @access_token.token
  session[:secret_token] = @access_token.secret
  session[:user_id] = @twitter.info['user_id']
  session[:screen_name] = @twitter.info['screen_name']
  session[:profile_image] = @twitter.info['profile_image_url_https']

  UserWorker.perform_async(
    @twitter.user_timeline(count: 200, exclude_replies: true),
    @twitter.info['screen_name']
  )

  redirect '/'
end

def base_url
  default_port = request.scheme == 'http' ? 80 : 443
  port = request.port == default_port ? '' : ":#{request.port}"
  "#{request.scheme}://#{request.host}#{port}"
end
