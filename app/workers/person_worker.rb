class PersonWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(person_id)
    person = Person.find(person_id)
    person.remote_photo_url = person.return_url
    person.images.each do |image|
      person.remote_photo_url = image.return_url
      image.save!
    end
    person.processed_images = true
    person.save!
  end
  
end