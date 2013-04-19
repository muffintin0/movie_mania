class Video
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  field :size, type: Integer, default: 0
  field :length, type: Integer, default: 0
  field :url, type: String

  validates :description, presence: true
  validates :size, numericality: {only_integer: true}
  validates :length, numericality: {only_integer: true}
  validates :url, presence: true, format: {with: /\Ahttps?:\/\/[\S]+\Z/}

  embedded_in :playable, polymorphic: true
end
