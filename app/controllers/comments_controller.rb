class CommentsController < ApplicationController
  before_action -> (entity: Tweet) { check_entity_existence entity }, only: [:create]

  def create
    comment = Comment.new(comment_params)
    comment.user_id = @current_user.id
    comment.tweet_id = params[:id]

    if comment.save
      render json: CommentBlueprint.render(comment, { root: :comment })
    else
      render :json => {
        errors: comment.errors
      }, status: 400
    end
  end

  private

  def comment_params
    params.permit(:content)
  end
end
