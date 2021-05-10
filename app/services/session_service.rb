class SessionService
  def self.create_session(user, password, response)
    unless user.authenticate(password)
      return render :json => {
        errors: "Wrong credentials"
      }, status: 400
    end

    token = JWT.encode({ user_id: user.id }, '193e313c5902b104a1881d0e41df89c1', 'HS256')

    response.set_cookie(:jwt, {
      value: token,
      expires: 1.week.from_now,
      httponly: true,
    })

    token
  end
end