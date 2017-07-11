# tree-a

1. `bundle install`をキメる。
1. `cp .env.sample .env`でコピーした後Slackに流れてるkeyに書き換える。
1. `sqlite3 twitter_tree.sqlite3`からの`.read create_db.sql`でファイルを生成する。


## sidekiq(非同期用サーバ)のセットアップ

1. `brew install redis` をキメる。
1. `redis-server` でredisを起動する。
1. `bundle exec sidekiq -r ./app.rb` でsidekiqを起動する。
