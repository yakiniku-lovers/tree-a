# frozen_string_literal: true

class UserWorker
  include Sidekiq::Worker

  def perform(_, user_name)
    # レコード(status:更新中)を作成
    if User.exists?(name: user_name)
      user = User.find_by(name: user_name)
      user.update!(status: UserStatuses::PROCESSING.value, url: nil)
    else
      user = User.new(name: user_name, status: UserStatuses::PROCESSING.value)
      user.save!
    end

    # jsonから特徴を取得
    puts 'generate feature...'
    sleep(10)

    # 特徴から画像を生成する
    puts 'generate image...'
    flower = Flower.new('./public/images/tree')
    image_path = flower.generate(colors: [200, 80, 80], number: 8, type: 2)

    # レコード(status: 完了)を更新
    user.update!(status: UserStatuses::COMPLETED.value, url: image_path)
  end
end
