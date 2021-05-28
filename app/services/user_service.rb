class UserService < ActionController::Base
  def self.update_user(user_id, params)
    user = User.find_by(id: user_id)

    user.update(params)

    if user.save
      return UserBlueprint.render_as_json(user, { root: :user })
    else
      return {
        errors: user.errors
      }
    end
  end
end
