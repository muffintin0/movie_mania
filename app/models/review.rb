class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :usefulness, type: Integer
  field :rating, type: Integer
  
  validates :rating, presence: true, numericality: {only_integer: true}
  validates :content, presence: true
  validates :usefulness, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  # :movie, index: true
  belongs_to :user, index: true
  
end