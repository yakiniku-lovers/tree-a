class TwitterClient
  attr_reader = :client

  def initialize()
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  # 指定したアカウントのプロフィールを表示
  def show_user_profile(user_name)
    puts @client.user(user_name).screen_name  #アカウントID
    puts @client.user(user_name).name         # アカウント名
    puts @client.user(user_name).description  # プロフィール
    puts @client.user(user_name).tweets_count # ツイート数
  end

  # 特定のユーザのタイムラインの表示
  def show_user_timeline(user_name, options = {})
    @client.user_timeline(user_name, options).each do |tweet|
      puts tweet.full_text
      puts "FAVORITE: #{tweet.favorite_count}"
      puts "RETWEET : #{tweet.retweet_count}"
    end
  end

  def json_user_timeline(user_name, options = {})
    tweets = @client.user_timeline(user_name, options)
    JSON.generate tweets.map { |tweet| tweet.attrs.to_json }
  end
end
