class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :gender, type: String
  field :identifier, type: String
  field :biography, type: String 
  field :portrait, type: String # the image url
  field :born, type: Hash #{dob:Date,place:String} optional 
  field :physical_attributes, type: Hash #{height:Float, weight:Float ...} optional
  field :official_site, type: String #optional
  field :trivias, type: Array #optional
  field :public_listings, type: Array #[{when,where,what}] #optional
  field :recent_works, type: Array #[{name,year}] three works

  #maintain relationships between people and movie
  # { "cast" => [movie_id,charactername], "crew" => [movie_id, title]}
  #field :movie_summaries, type: Hash 

  index({identifier: 1},{unique: true}) #for query
  index({name: 1, biography: 1, recent_works: 1}) #for search people 

  validates :name, presence: true
  validates :gender, presence: true, inclusion: {in: ["m","f"]}
  validates :identifier, uniqueness: true
  validates :biography, presence: true
  validates :portrait, presence: true

  embeds_many :images, as: :viewable
  embeds_many :videos, as: :playable
  has_many :cast_jobs
  has_many :crew_jobs

  validates_associated :images
  validates_associated :videos

  #has_and_belongs_to_many :movies, index: true

  before_validation :get_identifier

  def to_param
    self.identifier
  end
  
  # this method is also called in creating a movie's full crew
  def get_identifier
    self.identifier = 'p-'+self.name.gsub(/\s+/,'-').gsub(/\./,'-dot-')+'-'+self.born['dob']
  end

  def add_movie_as_cast(movie,character)
    self.movie_summaries = {"casts"=>[],"crews"=>[]} unless self.movie_summaries
    self.movie_summaries["casts"].push({"identifier"=>movie.get_identifier,"character"=>character})
  end

  def add_movie_as_crew(movie,title)
    self.movie_summaries = {"casts"=>[],"crews"=>[]} unless self.movie_summaries
    self.movie_summaries["crews"].push({"identifier"=>movie.get_identifier,"title"=>title})    
  end

end