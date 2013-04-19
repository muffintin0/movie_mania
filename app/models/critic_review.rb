class CriticReview < Review
	include Mongoid::Document
	include Mongoid::Timestamps

  field :represent, type: String
  
  validates :represent, presence: true
end