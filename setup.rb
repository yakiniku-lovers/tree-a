require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load

set :database, {adapter: 'sqlite3', database: 'twitter_tree.sqlite3'}

# modelの読み込み
Dir[File.expand_path('./model', __FILE__) << '/*.rb'].each do |file|
  require file
end

# ENUMの読み込み
Dir[File.expand_path('./enum', __FILE__) << '/*.rb'].each do |file|
  require file
end

enable :sessions