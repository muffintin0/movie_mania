class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :identifier, type: String 
  field :name, type: String
  field :overview, type: String
  field :storyline, type: String
  field :plot_keywords, type: Array
  field :motion_picture_rating, type: String
  field :runtime, type: Integer
  field :country, type: String
  field :language, type: String
  field :filming_locations, type: Array
  field :website, type: String #optional
  
  field :poster, type: String
  mount_uploader :photo, PhotoUploader
  
  field :official_trail, type: String
  field :release_time, type: Time
  field :budget, type: Float
  field :revenue, type: Float
  field :box_office, type: Array #[{week,revenue,rank},...] optional
  field :rating, type: Float, default: 0.0  # top rated movies
  field :votes, type: Integer, default: 0 # popular movies
  field :trivias, type: Array #optional

  #used to maintain relationship between movie and people
  #{"casts"=>[character,people_id],"crew"=>[title,person_id]}
  #field :personnels, type: Hash 

  embeds_many :images, as: :viewable, cascade_callbacks: true #so carrierwave will be trigged to create thumbnail
  embeds_many :videos, as: :playable
  embeds_many :reviews
  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :videos
  has_many :cast_jobs, :autosave => true
  has_many :crew_jobs, :autosave => true
  accepts_nested_attributes_for :cast_jobs
  accepts_nested_attributes_for :crew_jobs
  
  #has_many :reviews
  has_and_belongs_to_many :genres, index: true
  belongs_to :production_company, class_name: "ProductionCompany", index: true
  #accepts_nested_attributes_for :production_company

  validates :identifier, uniqueness: true
  validates :name, presence: true
  validates :overview, presence: true
  validates :storyline, presence: true
  validates :plot_keywords, presence: true
  #validates :personnels, presence: true
  validates :motion_picture_rating, presence: true, 
    inclusion: {in: ["G","PG","PG-13","NC-17","R","NR"]}
  validates :runtime, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :country, presence: true
  validates :language, presence: true
  validates :website, presence: true
  validates :poster, presence: true, format: {with: /\Ahttps?:\/\/[\S]+\Z/}
  validates :official_trail, presence: true, format: {with: /\Ahttps?:\/\/[\S]+\Z/}
  validates :release_time, presence: true
  validates :budget, numericality: {greater_than_or_equal_to: 0}
  validates :revenue, numericality: {greater_than_or_equal_to: 0}
  validates :rating, numericality: {greater_than_or_equal_to: 0}
  validates :votes, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  index({identifier: 1}, {unique: true}) # for identify movie
  index({name: 1, release_time: -1, motion_picture_rating: 1, genre_names:1, rating: -1, votes: -1, revenue: -1},
    {background: true}) # for searching and ranking movies
  index "reviews.usefulness" => 1 # get the most useful reivews 

  validates_associated :images
  validates_associated :videos
  validates_associated :reviews

  before_validation :get_identifier

  #after_save :update_casts_and_crews

  def as_json(options={})
    {
      id: id,
      identifier: identifier,
      name: name,
      overview: overview,
      storyline: storyline,
      plot_keywords: plot_keywords,
      full_crews: full_crews,
      motion_picture_rating: motion_picture_rating,
      runtime: runtime,
      country: country,
      language: language,
      filming_locations: filming_locations,
      website: website,
      poster: poster,
      official_trail: official_trail,
      release_time: release_time,
      budget: budget,
      revenue: revenue,
      box_office: box_office,
      rating: rating,
      votes: votes,
      trivias: trivias,
      movie_images: self.movie_images,
      movie_trails: self.movie_trails,
      reviews: self.reviews,
      genres: self.genres,
      casts: self.casts,
      crews: self.crews,
      production_company: self.production_company,
      created_at: created_at, 
      updated_at: updated_at
    }
  end

  def to_param
    self.identifier
  end

  def add_cast(person, character)
    self.personnels = { "casts"=> [], "crews" => [] } unless self.personnels
    self.personnels["casts"].push({"identifier"=>person.get_identifier,"character"=>character})
  end

  def include_cast?(person)
    if !self.personnels
      return false
    else
      self.personnels["casts"].collect{ |item| item["identifier"] }.include?(person.get_identifier)
    end
  end

  def add_crew(person, title)
    self.personnels = { "casts"=> [], "crews" => [] } unless self.personnels
    self.personnels["crews"].push({"identifier"=>person.get_identifier,"title"=>title})
  end

  def include_crew?(person)
    if !self.personnels
      return false
    else
      self.personnels["crews"].collect{ |item| item["identifier"] }.include?(person.get_identifier)
    end
  end

  def get_identifier
    self.identifier = 'm-'+self.name.gsub(/\s+/,'-').gsub(/\./,'-dot-')+"-"+self.release_time.strftime("%F")
  end
  
  def critic_reviews
    self.reviews.where("user.represent"=>{"$exists"=>true}) 
  end
  
  def process_photo
    # Download from S3
    #photo.cache_stored_file!
    # Convert to sanitized file for creating versions
    #photo.retrieve_from_cache!(photo.cache_name)

    # Loop through versions and create them....
    #photo.versions.values.each do |uploader|
    #  uploader.store!
    #end
    
    
    images.each do |image|
      # Download from S3
      image.photo.cache_stored_file!
      # Convert to sanitized file for creating versions
      image.photo.retrieve_from_cache!(image.photo.cache_name)
  
      # Loop through versions and create them....
      image.photo.versions.values.each do |uploader|
        uploader.store!
      end      
    end
  end
  
  # def update_casts_and_crews
  #   self.casts.each do |cast|
  #     cast.movie_summaries = [] unless cast.movie_summaries
  #     cast.movie_summaries.push({"id"=>self.id,"identifier"=>self.identifier,"name"=>self.name,
  #       "release_time"=>self.release_time,"character"=>cast.character})
  #     cast.save
  #   end
  #   self.crews.each do |crew|
  #     crew.movie_summaries = [] unless crew.movie_summaries
  #     crew.movie_summaries.push({"id"=>self.id,"identifier"=>self.identifier,"name"=>self.name,
  #       "release_time"=>self.release_time,"title"=>crew.title})
  #     crew.save
  #   end
  # end

end
