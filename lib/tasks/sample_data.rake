require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  	#make_genres
  	puts 'populated genres'
  	#make_production_companies
  	puts 'populated companies'
  	all_genres = Genre.all
  	all_companies = ProductionCompany.all

    #users = make_users
    users = User.all
  	puts 'created users and critics'

  	#people_pool= make_people
  	people_pool = Person.all
  	puts 'created people'

  	make_movie(all_genres,all_companies,users,people_pool)
  end
end

GENRES = [
	'Action',
	'Adventure',
	'Animation',
	'Biography',
	'Comedy',
	'Crime',
	'Documentary',
	'Drama',
	'Family',
	'Fantasy',
	'Film-Noir',
	'Game-Show',
	'Histroy',
	'Horror',
	'Music',
	'Musical',
	'Mystery',
	'News',
	'Reality-TV',
	'Romance',
	'Sci-Fi',
	'Sport',
	'Talk-Show',
	'Thriller',
	'War',
	'Western'
]

IMAGES = [
	'http://s3.amazonaws.com/Flow-Ming-Rails/uploads/20130131T2032Z_408ee0b2cf26b18e574292633d905565/long_grass.jpg',
	'http://s3.amazonaws.com/Flow-Ming-Rails/uploads/20130131T2032Z_408ee0b2cf26b18e574292633d905565/sunrise_over_the_ligurian.jpg',
	'http://s3.amazonaws.com/Flow-Ming-Rails/uploads/20130131T2032Z_408ee0b2cf26b18e574292633d905565/sunset_in_the_field.jpg',
	'http://s3.amazonaws.com/Flow-Ming-Rails/uploads/20130131T2032Z_408ee0b2cf26b18e574292633d905565/the_pier.jpg',
	'http://s3.amazonaws.com/Flow-Ming-Rails/uploads/20130131T2032Z_408ee0b2cf26b18e574292633d905565/the_tree.jpg',
	'http://s3.amazonaws.com/MovieImages_Spring/Boston-City-Flow1363303903020.jpg',
	'http://s3.amazonaws.com/MovieImages_Spring/Pensive-Parakeet1363148428336.jpg'
]

VIDEOS = [  
	'http://youtu.be/-NzRMPsnC3s',
	'http://youtu.be/TssZ9Uma1-w',
	'http://youtu.be/FQLGhPHzxjc',
	'http://youtu.be/z5u_2bGPdUY',
	'http://youtu.be/ehBVyXwwMN0',
	'http://youtu.be/QYLVd7plaV8',
	'http://youtu.be/Nj5ZgWqPCdU',
	'http://youtu.be/tFrjrgBV8K0',
	'http://youtu.be/_JJmDavBXrw',
	'http://youtu.be/PoGXr6hUTD4',
	'http://youtu.be/17qyaXOFZXg',
	'http://youtu.be/mfg7QJoa3o4',
	'http://youtu.be/huJpdolLjH0'
]

RATES = ['G','PG','PG-13','NR','R','NC-17']

ROLES = ['Producer', 'Executive Producer', 'Line Producer', 'Production Manager', 'Unit Manager', 'Production Coordinates',
	'Production Assistant', 'Screenwriter', 'Script Supervisor', 'Stunt Coordianator', 'Casting Director', 'Director', 
	'First Assistant Director', 'Second Assistant Director', 'Second Unit Director', 'Location Manager', 'Location Scout',
	'Production Designer', 'Art Director', 'Illustrator', 'Set Designer', 'Set Decorator', 'Costume Designer', 'Make-up Artist',
	'Special Effect Supervisor', 'Cinematographer', 'Director of Photography', 'Camera Operator', 'First Assistant Camera',
	'Second Assistant Camera','Production Sound Mixer', 'Film Editor', 'Visual Effects Producer', 'Visual Effects Supervisor',
	'Visual Effects Creative Director', 'Sound Designer', 'Dialogue Editor', 'Sound Editor', 'Music Supervisor', 'Composer']

def make_users
  users = []
  100.times {
    user = User.new
    user.nickname = Faker::Internet.user_name 
    user.email_address = Faker::Internet.email
    if user.save
      users.push(user)
    end
  }
  users #registered users
end

def make_genres
	GENRES.each do |genre_name|
		genre = Genre.new
		genre.name = genre_name
		genre.description = Faker::Lorem.sentences(3).join(' ')
		genre.save
	end
end

def make_production_companies
	100.times {
		production_company = ProductionCompany.new
		production_company.name = Faker::Lorem.words(5).join(' ')
		production_company.save
	}
end 

def make_people # make casts and crews
	people_pool = []
	100.times {
		person = Person.new
		person.name = Faker::Name.name
		person.gender = rand(10)%2 == 0 ? 'm' : 'f'
		person.biography = Faker::Lorem.sentences(rand(3)+6).join(' ')
    person.portrait = IMAGES[rand(IMAGES.count)] 
		born = {}
		born['dob'] = Time.at(rand*(6.years.ago.to_i)).strftime("%F")
		born['place'] = Faker::Lorem.words(10).join(' ')
		person.born = born
		physical_attributes = {}
		physical_attributes['weight'] = rand(100) + 100 #lb
		physical_attributes['height'] = 150 + rand(50) #cm
		person.physical_attributes = physical_attributes
		person.trivias = []
		3.times {
			trivia  = Faker::Lorem.sentences(2).join(' ')
			person.trivias.push(trivia)
		}
		person.public_listings = []
		5.times {
			public_listing = []
			public_listing.push(Time.at(person.born['dob'].to_i+rand*(Time.now.to_i-person.born['dob'].to_i)).strftime("%F"))
			public_listing.push(Faker::Lorem.words(8).join(' '))
			public_listing.push(Faker::Lorem.sentences(5).join(' '))
			person.public_listings.push(public_listing)
		}
    5.times {
      image = Image.new
      image.description = Faker::Lorem.words(3)[0]
      image.url = IMAGES[rand(IMAGES.count)]
      image.thumbnail_url = image.url
      image.size = rand(1000)
      image.delete_type = "f"
      person.images.push(image)
    } 
    5.times {
      trail = Video.new
      trail.description = Faker::Lorem.sentences(2).join(' ')
      trail.url = VIDEOS[rand(VIDEOS.count)]
      person.videos.push(trail)
    } 
    person.cast_jobs = []
    person.crew_jobs = []
    person.save! 
		people_pool.push(person)
	}
	people_pool
end

def make_movie(all_genres,all_companies,users,people_pool)
	10.times {
		movie = Movie.new
		movie.name = Faker::Name.name
		movie.overview = Faker::Lorem.sentences(10).join(' ')
		movie.storyline = Faker::Lorem.words(15).join(' ')
		movie.plot_keywords = Faker::Lorem.words(8)
		movie.motion_picture_rating = RATES[rand(RATES.count)]
		movie.language = 'en'
		movie.country = Faker::Lorem.words(10)[0]
		movie.runtime = rand(100)+90
		movie.filming_locations = Faker::Lorem.sentences(3)
		movie.website = Faker::Internet.url
		movie.poster = IMAGES[rand(IMAGES.count)] 
		movie.official_trail = VIDEOS[rand(VIDEOS.count)] 
		movie.release_time = Time.at(rand*Time.now.to_i)
		movie.budget = rand(100)
		movie.revenue = rand(150)
		movie.box_office = []
		for i in 0..10
			boxoffice = { "time" => (movie.release_time+i.weeks).strftime("%F"), "revenue" => rand(15-i), "rank" => rand(5+i)}
			movie.box_office.push(boxoffice)
		end
		movie.rating = (rand*100).floor/10.0
		movie.votes = rand(100000)
		movie.trivias = []
		3.times {
			trivia  = Faker::Lorem.sentences(2).join(' ')
			movie.trivias.push(trivia)
		}		
		movie.images = []
		movie.videos = []
		movie.genres = []
		5.times {
			image = Image.new
			image.description = Faker::Lorem.words(3)[0]
			image.url = IMAGES[rand(IMAGES.count)]
			image.thumbnail_url = image.url
			image.size = rand(1000)
			image.delete_type = "f"
			movie.images.push(image)
		}	
		5.times {
			trail = Video.new
			trail.description = Faker::Lorem.sentences(2).join(' ')
			trail.url = VIDEOS[rand(VIDEOS.count)]
			movie.videos.push(trail)
		}	
		3.times {
			genre = all_genres[rand(all_genres.count)]
			movie.genres.push(genre)
		}
		movie.production_company = all_companies[rand(all_companies.count)]
		movie.reviews = []
		10.times {
		  guest_review = Review.new
      guest_review.rating = rand(10)
      guest_review.usefulness = rand(1000)
      guest_review.content = Faker::Lorem.sentences(rand(10)+2).join(' ')		
      movie.reviews.push(guest_review)  
		}
		10.times {
		  user_review = Review.new
      user_review.rating = rand(10)
      user_review.usefulness = rand(1000)
      user_review.content = Faker::Lorem.sentences(rand(10)+2).join(' ') 
      user_review.user = users[rand(users.length)]
			movie.reviews.push(user_review)
		}
		3.times {
			critic_review = CriticReview.new
      critic_review.rating = rand(10)
      critic_review.usefulness = rand(1000)
      critic_review.content = Faker::Lorem.sentences(rand(10)+2).join(' ') 
      critic_review.user = users[rand(users.length)]
      critic_review.represent = Faker::Lorem.words(4).join(' ')
			movie.reviews.push(critic_review)
		}
		#add actors
		movie.cast_jobs = []
		num_casts = rand(20) + 10
		cast_counter = 0
		while cast_counter < num_casts
		  #the movie side
		  cast_job = CastJob.new
			cast_job.person = people_pool[rand(people_pool.length())]
			cast_job.character = Faker::Name.name
			cast_job.movie = movie
			#cast_job.save!
      movie.cast_jobs.push(cast_job)			
			cast_counter += 1
		end
		#add crews
		movie.crew_jobs = []
		ROLES.each do |title|
		  #the movie side
		  crew_job = CrewJob.new
		  crew_job.title = title
			crew_job.person = people_pool[rand(people_pool.length())]
			crew_job.movie = movie
			#crew_job.save!
      movie.crew_jobs.push(crew_job)
		end 	

		#p movie
		#p movie.casts[0]
		#p movie.crews[0]
		movie.save!
		puts "movie " + movie.name + " created"
	}
end