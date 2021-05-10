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

    user_id = decode_token(token)
    puts("user_id", user_id)

    unless user_id.nil?
      @current_user = User.find_by(id: user_id)
      return
    end

    render :json => {
      error: "Sign in first"
    }
  end

  def decode_token(token)
    begin
      decoded = JWT.decode(token, '193e313c5902b104a1881d0e41df89c1', true)
    rescue JWT::ExpiredSignature
      return render :json => {
        error: "Sign in again"
      }
    end

    unless decoded.nil?
      return decoded[0]["user_id"]
    end

    nil
  end
end
