class S3Image
  include Mongoid::Document  
  
  field :image_url, type: String

  def default_name
    self.name ||= File.basename(image_url, '.*').titleize if image_url
  end
   
end