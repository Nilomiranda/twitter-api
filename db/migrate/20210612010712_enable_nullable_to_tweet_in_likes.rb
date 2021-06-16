class EnableNullableToTweetInLikes < ActiveRecord::Migration[6.0]
  def up
    change_column_null :likes, :comment_id, true
    change_column_null :likes, :tweet_id, true
  end

  def down
    change_column :likes, :tweet_id, :integer, { null: false }
  end
end
