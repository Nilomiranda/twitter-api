class Tweet < ApplicationRecord
  paginates_per 10

  belongs_to :user

  validates :text, presence: true, length: { maximum: 300 }

  attr_accessor :current_user

  def liked
    return false unless self.current_user.present?

    !Like.find_by(user_id: self.current_user.id, tweet_id: self["id"]).nil?
  end
end
