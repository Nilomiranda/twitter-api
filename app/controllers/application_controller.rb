class ApplicationController < ActionController::API

  def api_status
    render :json => {
      :status => :online,
    }
  end
end
