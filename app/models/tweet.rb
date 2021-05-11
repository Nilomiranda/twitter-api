class Tweet < ApplicationRecord
  paginates_per 10

  belongs_to :user

  validates :text, presence: true
end
