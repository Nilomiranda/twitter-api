class SessionController < ApplicationController
  skip_before_action :require_login, only: [:create]

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

    token = SessionService.create_session(user, session_params[:password], response, request)

    if token.nil?
      render :json => {
        errors: "Wrong credentials. Please try again"
      }, status: 400
      return
    end

    render json: SessionBlueprint.render({ token: token, user: user }, { root: :data })
  end

  def destroy
    SessionService.delete_session(response)
  end

  def current
    render json: UserBlueprint.render(@current_user, { root: :user })
  end

  private

  def session_params
    params.permit(:email, :password, :nickname)
  end
end
