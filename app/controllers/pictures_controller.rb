class PicturesController < ApplicationController
  def new
    @picture = Picture.new(:user_id => params[:user_id])
  end

  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      flash[:success] = "Successfully created picture."
      redirect_to @picture.user
    else
      render :action => 'new'
    end
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(params[:picture])
      flash[:success] = "Successfully updated picture."
      redirect_to @picture.user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    flash[:success] = "Successfully destroyed picture."
    redirect_to @picture.user
  end
end