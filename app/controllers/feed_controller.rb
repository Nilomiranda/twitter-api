class FeedController < ApplicationController
  def index
    user_id = @current_user.id

    following_ids = params[:user_id] ? params[:user_id] : Following.where("follower_id = ?", user_id).select(:following_id)
    user_ids = params[:user_id] ? params[:user_id] : [@current_user.id, *following_ids.map { |following_id| following_id['following_id']  }  ]

    paginated_feed = PaginationService.paginate(
      Tweet.where('user_id IN(:user_ids)', { user_ids: user_ids }).order(created_at: :desc),
      params[:page],
      'feed',
    )

    paginated_feed['feed'] = paginated_feed['feed'].map do |tweet|
      tweet.current_user = @current_user
      tweet
    end

    render :json => {
      **paginated_feed,
      feed: FeedBlueprint.render_as_json(paginated_feed['feed'])
    }
  end
end
