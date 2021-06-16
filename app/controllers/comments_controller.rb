class CommentsController < ApplicationController
  before_action -> (entity = Tweet) { check_entity_existence entity }, only: [:create]
  before_action -> (entity = Comment) { check_entity_existence entity }, only: [:delete, :edit, :like]
  before_action -> (entity = Like) { check_entity_existence entity }, only: [:unlike]
  before_action -> (for_user = false, entity = Comment.find_by(id: params[:id])) { check_ownership(for_user, entity) }, only: [:delete, :edit]
  before_action -> (for_user = false, entity = Like.find_by(id: params[:id])) { check_ownership(for_user, entity) }, only: [:unlike]

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

  def edit
    comment = Comment.find_by(id: params[:id])
    comment.content = comment_params[:content]

    if comment.save
      render json: CommentBlueprint.render(comment, { root: :comment })
    else
      render :json => {
        errors: comment.errors
      }, status: 400
    end
  end

  def like
    like = Like.create(user_id: @current_user.id, comment_id: params[:id])

    render :json => {
      errors: like.errors,
    }, status: 500 unless like.save
  end

  def unlike

  end

  private

  def comment_params
    params.permit(:content)
  end
end
