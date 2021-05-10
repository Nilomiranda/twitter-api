class UserController < ApplicationController
  skip_before_action :require_login, only: [:create, :read]

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
    user_id = params[:id]

    if user_id.nil?
      return render :json => {
        errors: "User not found"
      }, status: 404
    end

    user = User.find_by(id: user_id)

    if user.nil?
      return render :json => {
        errors: "User not found"
      }, status: 404
    end

    render json: UserBlueprint.render(user, { root: :user })
  end

  def update

  end

  private

  def user_params
    params.permit(:nickname, :email, :password)
  end
end
