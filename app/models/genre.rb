class Genre
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  has_and_belongs_to_many :movies, index: true

  validates :name, presence: true
  validates :description, presence: true

  def as_json(opitons={})
  	{id: id, name: name, description: description, created_at: created_at, updated_at: updated_at}
  end

  def to_s
  	self.name
  end

end
