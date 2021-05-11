class UserController < ApplicationController
  skip_before_action :require_login, only: [:create, :read, :tweets]
  before_action -> (entity = User) { check_entity_existence entity }, only: [:read, :update, :destroy]
  before_action -> (for_user = true) { check_ownership for_user }, only: [:update, :destroy]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserBlueprint.render(@user, { root: :user })
    else
      render :json => {
        errors: @user.errors
      }, status: 400
    end
  end

  def read
    render json: UserBlueprint.render(@target_entity, { root: :user })
  end

  def update
    @target_entity.update(edit_user_params)

    if @target_entity.save
      render json: UserBlueprint.render(@target_entity, { root: :user })
    else
      return render :json => {
        errors: @target_entity.errors
      }
    end
  end

  def destroy
    if @target_entity.destroy
      SessionService.delete_session(response, cookies)
    end
  end

  def tweets
    user_id = params[:id]
    tweets = Tweet.where(user_id: user_id).page(params[:page] || 1)
    render json: TweetBlueprint.render(tweets, { root: :tweets })
  end

  private

  def user_params
    params.permit(:nickname, :email, :password)
  end

  def edit_user_params
    params.permit(:nickname, :email, :password)
  end
end
