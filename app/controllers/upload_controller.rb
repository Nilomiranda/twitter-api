class UploadController < ApplicationController
  def create
    upload_result = Cloudinary::Uploader.upload(params[:file], :folder => "twitter-clone-media", :resource_type => "image")
    render :json => {
      path: upload_result["secure_url"]
    }
  end
end
