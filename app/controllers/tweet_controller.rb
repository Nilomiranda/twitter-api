class TweetController < ApplicationController
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
