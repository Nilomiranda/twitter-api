class UserController < ApplicationController
  skip_before_action :require_login, only: [:create]

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
    render json: UserBlueprint.render(@current_user, { root: :user })
  end

  private

  def user_params
    params.permit(:nickname, :email, :password)
  end
end
