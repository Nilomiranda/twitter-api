class UserController < ApplicationController
  skip_before_action :require_login, only: [:create, :read, :tweets]
  before_action -> (entity = User) { check_entity_existence entity }, only: [:read, :update, :destroy, :tweets]
  before_action -> (for_user = true) { check_ownership for_user }, only: [:update, :destroy]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserBlueprint.render(@user, { root: :user })
    else
      render :json => {
        errors: @user.errors
      }, status: 400
    end
  end

  def read
    render json: UserBlueprint.render(@target_entity, { root: :user })
  end

  def update
    @target_entity.update(edit_user_params)

    if @target_entity.save
      render json: UserBlueprint.render(@target_entity, { root: :user })
    else
      return render :json => {
        errors: @target_entity.errors
      }
    end
  end

  def destroy
    if @target_entity.destroy
      SessionService.delete_session(response, cookies)
    end
  end

  def tweets
    user = User.find_by(id: params[:id])
    paginated_tweets = PaginationService.paginate(user.tweets, params[:page] || 1, "tweets")
    render :json => {
      tweets: TweetBlueprint.render_as_json(paginated_tweets["tweets"]),
      **paginated_tweets
    }
  end

  private

  def user_params
    params.permit(:nickname, :email, :password)
  end

  def edit_user_params
    params.permit(:nickname, :email, :password)
  end
end
