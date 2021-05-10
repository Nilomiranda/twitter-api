class UserController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserBlueprint.render(@user, { root: :user })
    else
      render :json => {
        error: "Error saving user"
      }
    end
  end

  private

  def user_params
    params.permit(:nickname, :email, :password)
  end
end
