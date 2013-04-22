class PeopleController < ApplicationController
  
  def index
    @people = Person.all
    respond_to do |format|
      format.json {render json: @people}
      format.html
    end     
  end
  
  def new
    @person = Person.new
    @person.physical_attributes = {}
    @person.physical_attributes["height"]=0.0
    @person.physical_attributes["weight"]=0
    respond_to do |format|
     format.html  { render :new, :layout => "plain"}
    end
  end
  
  def create
    @person = Person.new(params[:person])
    @person.processed_images = false #the thumbnails have not been created yet, use background worker to do that
    respond_to do |format|
      if @person.save
        PhotoWorker.perform_async(@person.id)        
        flash[:success] = "Person was successfully created"
        format.html { redirect_to @person }
        format.json { render json: @person, status: :created, location: @movie}
      else
        format.html { render action: 'new', :layout => "plain" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end    
  end
  
  
end