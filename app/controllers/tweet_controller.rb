class TweetController < ApplicationController
  skip_before_action :require_login, only: [:read]
  before_action -> (entity = Tweet) { check_entity_existence entity }, only: [:read, :update, :destroy]
  before_action :check_ownership, only: [:update, :destroy]

  def create
    tweet = Tweet.new(tweet_params)

    tweet.user = @current_user

    if tweet.save
      return render json: TweetBlueprint.render(tweet, { root: :tweet, view: :extended })
    else
      return render :json => {
        errors: tweet.errors
      }, status: 400
    end
  end

  def index
    paginated_tweets = PaginationService.paginate(Tweet, params[:page] || 1, "tweets")
    render :json => {
      tweets: TweetBlueprint.render_as_json(Tweet.page(params[:page] || 1), { view: :extended }),
      **paginated_tweets
    }
  end

  def read
    render json: TweetBlueprint.render(@target_entity, { root: :tweet })
  end

  def update
    @target_entity.update(tweet_params)

    if @target_entity.save
      render json: TweetBlueprint.render(@target_entity, { root: :tweet,  view: :extended })
    else
      return render :json => {
        errors: @target_entity.errors
      }
    end
  end

  def destroy
    @target_entity.destroy
  end

  private

  def tweet_params
    params.permit(:text)
  end
end
