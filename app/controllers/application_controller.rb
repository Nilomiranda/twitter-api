class ApplicationController < ActionController::API
  before_action :require_login

  include ActionController::Cookies

  def api_status
    render :json => {
      :status => :online,
    }
  end

  private

  def require_login
    token = cookies[:jwt]

    if token.nil?
      return render :json => {
        error: "Sign in first"
      }
    end

    user_id = decode_jwt_token_and_get_user_id(token)
    puts("user_id", user_id)

    unless user_id.nil?
      @current_user = User.find_by(id: user_id)
    else
      return render :json => {
        error: "Sign in first"
      }
    end
  end

  def decode_jwt_token_and_get_user_id(token)
    decoded = JWT.decode(token, '193e313c5902b104a1881d0e41df89c1', true)

    unless decoded.nil?
      decoded[0]["user_id"]
    else
      nil
    end
  end
end
