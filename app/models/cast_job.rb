class CastJob
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :character, type: String
  #field :movie_summaries, type: Array #[{movie_id,movie_identifier,movie_name,date,charactername}] shortverion of movie
  belongs_to :movie, index: true
  belongs_to :person, index: true

  validates :character, presence: true
  
  def to_name
    character + person
  end
  
end