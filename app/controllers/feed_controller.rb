class FeedController < ApplicationController
  def index
    user_id = @current_user.id

    following_ids = Following.where("follower_id = ?", user_id).select(:following_id)

    paginated_feed = PaginationService.paginate(
      Tweet.where('user_id IN(:user_ids)', { user_ids: [@current_user.id, *following_ids.map { |following_id| following_id['following_id']  }  ] }).order(created_at: :desc),
      params[:page],
      'feed',
    )

    render :json => {
      **paginated_feed,
      feed: FeedBlueprint.render_as_json(paginated_feed['feed'])
    }
  end
end
