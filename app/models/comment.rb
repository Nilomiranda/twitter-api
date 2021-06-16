class Comment < ApplicationRecord
  belongs_to :tweet
  belongs_to :user

  validates_presence_of :content
  validates_length_of :content, minimum: 1, maximum: 300, too_long: "Comment can't be longer than 300 characters"
end
