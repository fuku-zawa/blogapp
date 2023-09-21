# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorite_articles, through: :likes, source: :article
  
  # 自分がfollowしている人を取得するための関係
  # userモデルはhas_many　following_relationships（フォローしているときのデータを持ってくるのでfollowing_relationshipという名前にした　こんなモデルはない）だよ。
  # Relationshipモデルのことで外部キーはfollower_idだよと指定してあげる
  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  # フォローしている人を取得するにはrelationshipsテーブルを経由して取得してくる→through
  # フォローしている人followingsをfollowing_relationshipsからとってくる。followingsモデルはないのでsource
  has_many :followings, through: :following_relationships, source: :following
  
  # 自分のfollowerを取得するための関係（↑の逆をする）
  has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_one :profile, dependent: :destroy

  delegate :birthday, :age, :gender, to: :profile, allow_nil: true

  # 自分が書いた記事かどうかの判定
  def has_written?(article)
    articles.exists?(id: article.id)
  end

  def has_liked?(article)
    likes.exists?(article_id: article.id)
  end

  def display_name
    # if profile && profile.nickname
    #   profile.nickname
    # else
    #   self.email.split('@')[0]
    # end

    # ぼっち演算子
    profile&.nickname || self.email.split('@')[0]
  end

  # followしている人を取得する
  # following_idは引数userを渡す
  def follow!(user)
    following_relationships.create!(following_id: user.id)
  end

  # followを外す機能
  def unfollow!(user)
    # followingの相手は必ず見つからないといけないのでfind_byに!をつける
    relation = following_relationships.find_by!(following_id: user.id)
    relation.destroy!
  end

  def prepare_profile
    profile || build_profile
  end

  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      'default-avatar.png'
    end
  end

end
