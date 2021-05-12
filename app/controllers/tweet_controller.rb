class TweetController < ApplicationController
  skip_before_action :require_login, only: [:read]
  before_action -> (entity = Tweet) { check_entity_existence entity }, only: [:read, :update, :destroy]
  before_action -> (for_user = false, tweet = Tweet.find_by(id: params[:id])) { check_ownership(for_user, tweet) }, only: [:update, :destroy]


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
      **paginated_tweets,
      tweets: TweetBlueprint.render_as_json(paginated_tweets["tweets"], { view: :extended })
    }
  end

  def read
    tweet = Tweet.find_by(id: params[:id])
    render json: TweetBlueprint.render(tweet, { root: :tweet, view: :extended })
  end

  def update
    tweet = Tweet.find_by(id: params[:id])

    tweet.update(tweet_params)

    if tweet.save
      render json: TweetBlueprint.render(tweet, { root: :tweet,  view: :extended })
    else
      return render :json => {
        errors: tweet.errors
      }
    end
  end

  def destroy
    tweet = Tweet.find_by(id: params[:id])

    tweet.destroy
  end

  private

  def tweet_params
    params.permit(:text)
  end
end
