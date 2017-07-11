require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load

set :database, {adapter: 'sqlite3', database: 'twitter_tree.sqlite3'}

# modelの読み込み
require './model/User.rb'
# Dir[File.expand_path('./model', __FILE__) << '/*.rb'].each do |file|
#   require file
# end

# ENUMの読み込み
require './enum/user_statuses.rb'
# Dir[File.expand_path('./enum', __FILE__) << '/*.rb'].each do |file|
#   require file
# end

require './worker/user_worker.rb'

enable :sessions
