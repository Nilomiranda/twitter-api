class UserController < ApplicationController
  skip_before_action :require_login, only: [:create, :read, :tweets]
  before_action -> (entity = User) { check_entity_existence entity }, only: [:read, :update, :destroy, :tweets]
  before_action -> (for_user = true, user = User.find_by(id: params[:id])) { check_ownership(for_user, user) }, only: [:update, :destroy]

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

  def search
    query = params[:query]
    paginated_search = PaginationService.paginate2(
      User.where('nickname LIKE :nickname OR email LIKE :email', { nickname: "%#{query}%", email: "%#{query}%" }).order(followers_count: :desc),
      params[:page],
      'users',
    )

    render :json => {
      **paginated_search,
      users: UserBlueprint.render_as_json(paginated_search['users'])
    }
  end

  def read
    user = User.find_by(id: params[:id])

    render json: UserBlueprint.render(user, { root: :user })
  end

  def update
    user = User.find_by(id: params[:id])

    user.update(edit_user_params)

    if user.save
      render json: UserBlueprint.render(user, { root: :user })
    else
      return render :json => {
        errors: user.errors
      }
    end
  end

  def destroy
    user = User.find_by(id: params[:id])

    if user.destroy
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
