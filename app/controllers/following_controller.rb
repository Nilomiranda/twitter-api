class FollowingController < ApplicationController
  before_action -> (entity = User) { check_entity_existence entity }, only: [:create, :destroy]

  def create
    if params[:id].to_i == @current_user.id.to_i
      return
    end

    user_to_follow = User.find_by(id: params[:id])

    following = Following.new(following_id: user_to_follow.id, follower_id: @current_user.id)

    existent_following = Following.where(following_id: user_to_follow.id, follower_id: @current_user.id)

    if existent_following.present?
      return
    end

    User.transaction do
      following.save!
      @current_user.increment!(:following_count)
      user_to_follow.increment!(:followers_count)
    end
  end

  def destroy
    if params[:id].to_i == @current_user.id.to_i
      return
    end

    user_to_unfollow = User.find_by(id: params[:id])

    following = Following.where(following_id: user_to_unfollow.id, follower_id: @current_user.id)

    unless following[0].present?
      return render :json => {
        errors: "Not found"
      }, status: :not_found
    end

    User.transaction do
      following[0].destroy!
      @current_user.decrement!(:following_count)
      user_to_unfollow.decrement!(:followers_count)
    end
  end

  def followers
    followers = Following.references(:follower).where('followings.following_id' => params[:user_id])
    render json: FollowBlueprint.render(followers, { view: :followers, root: :followers })
  end

  def following
    followed_user_id = params[:id]
    unless followed_user_id.nil?
      is_following = Following.where("followings.follower_id = :user_id AND followings.following_id = :followed_user_id", { user_id: params[:user_id], followed_user_id: followed_user_id }).exists?
      return render :json => {
        following: is_following
      }
    end

    following = Following.references(:following).where('followings.follower_id' => params[:user_id])
    render json: FollowBlueprint.render(following, { view: :following, root: :following })
  end
end
