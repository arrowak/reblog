class CloudsharesController < ApplicationController
  def create
    @cloudshare = Cloudshare.new(post_params)

    if @cloudshare.save
      render json: {:link => "#{@cloudshare.image.url}"}
    else
      render json: {:error => "Failed to upload image to cloud."}
    end

  end

  private
  def post_params
    params.require(:cloudshare).permit(:image)
  end
end
