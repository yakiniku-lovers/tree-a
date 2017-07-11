class UserWorker
  include Sidekiq::Worker

  def perform(data, user_name)
    puts 'user:' + user_name

    # レコード(status:更新中)を作成
    users = User.where(name: user_name)
    if users.empty?
      user = User.new(name: user_name, status: UserStatuses::PROCESSING.value)
      user.save!
    else
      user = users.first
      user.update(status: UserStatuses::PROCESSING.value, url: nil)
    end

    # jsonから特徴を取得
    puts 'generate feature...'
    sleep(10)

    # 特徴から画像を生成する
    puts 'generate image...'
    sleep(20)
    image_path = '/foo/hogefuga.png'

    # レコード(status: 完了)を更新
    user.update!(status: UserStatuses::COMPLETED.value, url: image_path)
  end
end
