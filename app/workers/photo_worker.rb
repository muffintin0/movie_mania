class PhotoWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(movie_id)
    movie = Movie.find(movie_id)
    movie.remote_photo_url = movie.return_url
    movie.images.each do |image|
      image.remote_photo_url = image.return_url
      image.save!
    end
    movie.processed_images = true
    movie.save!
  end
  
end
