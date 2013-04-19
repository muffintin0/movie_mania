class User 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_protected :provider, :uid, :name
  
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String
  
  #validates :email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/}
  #validates :name, uniqueness: true, length: { minimum: 4}, format: {with: /\A[A-Za-z0-9_+-]+\z/}
  
  has_many :reviews
  has_many :pictures

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end

end