class ApplicationController < ActionController::API
  before_action :require_login

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
    @target_entity = entity.find_by(id: params[:id])

    if @target_entity.nil?
      return render :json => {
        errors: "Not found"
      }, status: 404
    end

    @target_entity
  end

  # before editing, or destroying, this can be used
  # to ensure that the requesting agent is the entry
  # entity
  def check_ownership(for_user = false)
    if for_user && @current_user.id != @target_entity.id
      return render :json => {
        errors: "You can only #{action_name.downcase} your own profile"
      }, status: 403
    end

    if for_user && @current_user.id == @target_entity.id
      return
    end

    if @current_user.id != @target_entity.user.id
      render :json => {
        errors: "You can only #{action_name.downcase} your own #{@target_entity.class.name.downcase}"
      }, status: 403
    end
  end

  def require_login
    token = cookies[:jwt] if cookies[:jwt].present?

    if token.nil?
      return render :json => {
        error: "Sign in first"
      }, status: 401
    end

    user_id = decode_token(token)
    puts("user_id", user_id)

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
