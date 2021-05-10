class SessionController < ApplicationController
  def create
    if !session_params[:email].present? && !session_params[:nickname].present?
      render :json => {
        errors: "Either email or nickname is required",
      }, status: 400
    end

    user = User.where(["email = :email OR nickname = :nickname", {
      email: session_params[:email],
      nickname: session_params[:nickname]
    }]).first

    if user.nil?
      render :json => {
        errors: "User not found"
      }, status: 404
      return
    end

    unless user.authenticate(session_params[:password])
      return render :json => {
        errors: "Wrong credentials"
      }, status: 400
    end

    render json: UserBlueprint.render(user, { root: :user })
  end

  private

  def session_params
    params.permit(:email, :password, :nickname)
  end
end
