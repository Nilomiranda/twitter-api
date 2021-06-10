class Tweet < ApplicationRecord
  paginates_per 10

  belongs_to :user

  validates :text, presence: true, length: { maximum: 300 }

  attr_accessor :liked
end
