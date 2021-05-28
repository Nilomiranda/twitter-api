class UserService < ActionController::Base
  def update_user(user_id, params)
    user = User.find_by(id: user_id)

    if params[:new_password].present?
      begin
        update_user_password(user, params)
      rescue ArgumentError => error
        return {
          errors: error
        }
      end
      params[:password] = params[:new_password]
    end

    params.delete("new_password")
    params.delete("new_password_confirmation")
    params.delete("current_password")

    user.update(params)

    if user.save
      return UserBlueprint.render_as_json(user, { root: :user })
    else
      return {
        errors: user.errors
      }
    end
  end

  private

  def update_user_password(user, params)
    raise ArgumentError.new 'Missing required fields: current password and new password confirmation' unless params[:current_password].present? && params[:new_password_confirmation].present?

    raise ArgumentError.new 'Incorrect password' unless BCrypt::Password.new(user.password_digest) == params[:current_password]

    raise ArgumentError.new "New password and password confirmation don't match." unless params[:new_password] == params[:new_password_confirmation]
  end

end
