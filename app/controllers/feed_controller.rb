class FeedController < ApplicationController
  def index
    user_id = @current_user.id

    following_ids = Following.where("follower_id = ?", user_id).select(:following_id)
    puts('following_ids', following_ids.as_json)

    return render json: FeedBlueprint.render([], { root: :feed }) unless following_ids.length != 0

    paginated_feed = PaginationService.paginate(
      Tweet,
      params[:page],
      'feed',
      { string: 'user_id IN(:user_ids)', params: { user_ids: following_ids.map { |following_id| following_id['following_id']  } } }
    )

    render :json => {
      **paginated_feed,
      feed: FeedBlueprint.render_as_json(paginated_feed['feed'])
    }
  end
end
