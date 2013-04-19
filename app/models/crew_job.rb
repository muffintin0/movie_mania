class CrewJob
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  #field :movie_summaries, type: Array #[{movie_id,movie_identifier,movie_name,date,title}] shortverion of movie
  belongs_to :movie, index: true
  belongs_to :person, index: true
  
  validates :title, presence: true
  
end