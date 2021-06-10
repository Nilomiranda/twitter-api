class CommentsController < ApplicationController
  before_action -> (entity = Tweet) { check_entity_existence entity }, only: [:create]
  before_action -> (entity = Comment) { check_entity_existence entity }, only: [:delete, :update]
  before_action -> (for_user = false, entity = Comment.find_by(id: params[:id])) { check_ownership(for_user, entity) }, only: [:delete, :update]

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

  def delete
    comment = Comment.find_by(id: params[:id])
    comment.destroy
  end

  private

  def comment_params
    params.permit(:content)
  end
end
