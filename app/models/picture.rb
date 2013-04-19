class Picture
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  
  belongs_to :user
  
  mount_uploader :photo, PhotoUploader
end