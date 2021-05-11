class TweetController < ApplicationController
  skip_before_action :require_login, only: [:index]
  def create
    tweet = Tweet.new(tweet_params)

    tweet.user = @current_user

    if tweet.save
      return render json: TweetBlueprint.render(tweet, { root: :tweet })
    else
      return render :json => {
        errors: tweet.errors
      }, status: 400
    end
  end

  def index
    render json: TweetBlueprint.render(Tweet.page(params[:page] || 1), { root: :tweets })
  end

  def read
    tweet_id = params[:id] if params[:id].present?

    if tweet_id.nil?
      return render :json => {
        errors: "Tweet not found"
      }, status: 404
    end

    tweet = Tweet.find_by(id: tweet_id)

    if tweet.nil?
      return render :json => {
        errors: "Tweet not found"
      }, status: 404
    end

    render json: TweetBlueprint.render(tweet, { root: :tweet })
  end

  def update
    tweet_id = params[:id] if params[:id].present?

    if tweet_id.nil?
      return render :json => {
        errors: "Tweet not found"
      }, status: 404
    end

    tweet = Tweet.find_by(id: tweet_id)

    if tweet.nil?
      return render :json => {
        errors: "Tweet not found"
      }, status: 404
    end

    tweet.update(tweet_params)

    if tweet.save
      render json: TweetBlueprint.render(tweet, { root: :tweet })
    else
      return render :json => {
        errors: tweet.errors
      }
    end
  end

  def destroy
    tweet_id = params[:id] if params[:id].present?

    if tweet_id.nil?
      return render :json => {
        errors: "Tweet not found"
      }, status: 404
    end

    tweet = Tweet.find_by(id: tweet_id)

    if tweet.nil?
      return render :json => {
        errors: "Tweet not found"
      }, status: 404
    end

    tweet.destroy
  end

  private

  def tweet_params
    params.permit(:text)
  end
end
