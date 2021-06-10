class LikesController < ApplicationController
  before_action -> (entity: Tweet) { check_entity_existence entity }, only: :create
  before_action -> (entity: Like) { check_entity_existence entity }, only: :delete
  before_action -> (for_user = false, like = Like.find_by(id: params[:id])) { check_ownership(for_user, like) }, only: [:delete]

  def create
    tweet = Tweet.find_by(id: params[:id])
    like = Like.new(user_id: @current_user.id, tweet_id: tweet.id)

    existing_like = Like.find_by(user_id: @current_user.id, tweet_id: tweet.id)

    return unless existing_like.nil?

    begin
      like.save
    rescue
      render :json => {
        errors: 'An unexpected error occurred'
      }, status: 500
    end
  end

  def delete
    like = Like.find_by(id: params[:id])

    begin
      like.destroy
    rescue
      render :json => {
        errors: 'An unexpected error occurred'
      }, status: 500
    end
  end

  def index
    paginated_likes = PaginationService.paginate(Like.where(tweet_id: params[:id]), params[:page], 'likes')
    users = paginated_likes['likes'].map { |like| like.user }

    render :json => {
      **paginated_likes,
      users: UserBlueprint.render_as_json(users)
    }.except('likes')
  end
end
