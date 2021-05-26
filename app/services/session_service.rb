class SessionService
  @token_expiration = Time.now.to_i + 1.week

  def self.create_session(user, password, response, request)
    unless user.authenticate(password)
      return nil
    end

    token = JWT.encode({ user_id: user.id, exp: @token_expiration }, '193e313c5902b104a1881d0e41df89c1', 'HS256')

    response.set_cookie(:jwt, {
      value: token,
      expires: 1.week.from_now,
      httponly: true,
    })
    token
  end

  def self.delete_session(response, cookies)
    cookies.delete :jwt
  end
end