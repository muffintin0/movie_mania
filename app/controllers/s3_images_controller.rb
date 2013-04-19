class S3ImageController < ApplicationController
  
  def create
    @image = S3Image.create(params[:s3_image])
    
  end
end