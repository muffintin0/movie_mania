class MoviesController < ApplicationController

	def index
		#infinite scolling
		@movies = Movie.includes(:genres).only(:identifier,:name,:storyline,:release_time,:genre_ids,
		  :motion_picture_rating,:revenue,:rating,:votes,:poster).limit(20)
		@moviesTotal = Movie.count
		p @movies.first
		respond_to do |format|
			format.html
			format.json {render json: @movies}
		end	
	end

	def getMore
		skip = params[:skip]
		@movies = Movie.includes(:genres).only(:identifier,:name,:storyline,:release_time,:genre_ids,
      :motion_picture_rating,:revenue,:rating,:votes,:poster).skip(skip).limit(20)
		respond_to do |format|
			format.js
		end
	end
	
	def personSelector
	  @type = params[:type]
    respond_to do |format|
      format.js
    end	  
	end

	def show
		@movie = Movie.includes(:cast_jobs).includes(:crew_jobs).where(identifier: params[:id]).first
		@user_reviews = @movie.reviews.any_of({:user_id=>nil},{:represent.exists => false}).page(params[:user_review_page]).per(10)
		@critic_reviews = @movie.reviews.where(:represent.exists => true ).page(params[:critic_review_page]).per(10)
		respond_to do |format|
      format.json {render json: @movie}
      format.js
			format.html
		end
	end

	def edit 
		@movie = Movie.where(identifier: params[:id]).first
	end
	
	def new
	 @movie = Movie.new 
	 @movie.genres.build
	 @movie.cast_jobs.build
	 @movie.crew_jobs.build
	 @movie.build_production_company
	 respond_to do |format|
	   format.html  { render :new, :layout => "plain"}
	 end
	end

	def create
		#pass in genre_ids array
		@movie = Movie.new(params[:movie])
		@movie.processed_images = false #the thumbnails have not been created yet, use background worker to do that
		respond_to do |format|
			if @movie.save
			  PhotoWorker.perform_async(@movie.id)			  
			  flash[:success] = "Movie was successfully created"
				format.html { redirect_to @movie }
				format.json { render json: @movie, status: :created, location: @movie}
			else
				format.html { render action: 'new', :layout => "plain" }
				format.json { render json: @movie.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		#pass in genre_ids array
		@movie = Movie.find(params[:id])
		respond_to do |format|
			if @movie.update_attributes(params[:movie])
			  flash[:success] = 'Movie was successfully updated.'
				format.html { redirect_to @movie }
				format.json { render json: @movie, status: 200, location: @movie}
			else
				format.html { render action: 'edit' }
				format.json { render json: @movie.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@movie = Movie.where(:identifier => params[:id])
		@movie.destroy
		respond_to do |format|
		  flash["success"] = 'Movie was successfully deleted.'
			format.html { redirect_to movies_path }
			format.json { head :no_content}
		end
	end
end


