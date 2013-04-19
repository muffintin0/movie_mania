class Image
	include Mongoid::Document
	include Mongoid::Timestamps

  field :description, type: String
  field :thumbnail_url, type: String
  field :url, type: String
  field :size, type: Integer, default: 0
  field :delete_type, type: String
  
  mount_uploader :photo, PhotoUploader

  #validates :description, presence: true
  validates :url, presence: true, format: {with: /\Ahttps?:\/\/[\S]+\Z/}
  validates :size, numericality: {only_integer: true}

  embedded_in :viewable, polymorphic: true
  
end
