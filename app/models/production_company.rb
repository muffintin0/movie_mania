class ProductionCompany
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :identifier, type: String

	validates :name, presence: true
	validates :identifier, presence: true, uniqueness: true
	
	index({name: 1, identifier: 1}) #for search company

	has_many :movies

	before_validation :create_identifier

  def to_param
    self.identifier
  end
  
	protected
		def create_identifier
			self.identifier = self.name.gsub(/\s+/,'-').gsub(/\./,'-dot-')
		end

end