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

    token = JWT.encode(user.id, '193e313c5902b104a1881d0e41df89c1', 'HS256')

    response.set_cookie(:jwt, {
      value: token,
      expires: 1.week.from_now,
      httponly: true,
    })

    render json: UserBlueprint.render(user, { root: :user })
  end

  private

  def session_params
    params.permit(:email, :password, :nickname)
  end
end
