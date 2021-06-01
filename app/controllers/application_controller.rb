class ApplicationController < ActionController::API
  before_action :require_login, except: [:api_status]

  include ActionController::Cookies

  def api_status
    render :json => {
      :status => :online,
    }
  end

  private

  # before editing, reading or destroying, read
  # and make sure entity exists in the first place
  def check_entity_existence(entity)
    exists = entity.exists?(params[:id])

    if !exists
      return render :json => {
        errors: "Not found"
      }, status: 404
    end
  end

  # before editing, or destroying, this can be used
  # to ensure that the requesting agent is the entry
  # entity
  def check_ownership(for_user = false, entity)
    if for_user && @current_user.id != entity.id
      return render :json => {
        errors: "You can only #{action_name.downcase} your own profile"
      }, status: 403
    end

    if for_user && @current_user.id == entity.id
      return
    end

    if @current_user.id != entity.user.id
      render :json => {
        errors: "You can only #{action_name.downcase} your own #{entity.class.name.downcase}"
      }, status: 403
    end
  end

  def read_token_from_authorization_headers
    authorization_header = request.authorization
    pattern = /^Bearer /
    authorization_header.gsub(pattern, '') if authorization_header && authorization_header.match(pattern)
  end

  def require_login
    token = cookies[:jwt] if cookies[:jwt].present?

    token = read_token_from_authorization_headers if token.nil?

    if token.nil?
      return render :json => {
        error: "Sign in first"
      }, status: 401
    end

    user_id = decode_token(token)
    unless user_id.nil?
      @current_user = User.find_by(id: user_id)
      return
    end

    render :json => {
      error: "Sign in first"
    }, status: 401
  end

  def decode_token(token)
    begin
      decoded = JWT.decode(token, '193e313c5902b104a1881d0e41df89c1', true)
    rescue JWT::ExpiredSignature
      return render :json => {
        error: "Sign in again"
      }, status: 401
    end

    unless decoded.nil?
      return decoded[0]["user_id"]
    end

    nil
  end

end
