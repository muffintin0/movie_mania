source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'mongoid'
gem 'bson'
gem 'bson_ext'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#handler form
gem "nested_form", :git => 'git://github.com/ryanb/nested_form.git'
gem 'simple_form'
gem 'country_select'

#upload to s3
gem 's3_direct_upload'

#carrierwave for image processing 
gem "rmagick"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem "fog", "~> 1.3.1" #carrierwave with s3
gem 'carrierwave_direct'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'kaminari' #pagination

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'zurb-foundation', '~> 4.0.0'
  gem 'foundation-icons-sass-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

#twitter authentication
gem "omniauth", ">= 1.1.0"
gem "omniauth-twitter"

group :development, :test do
  gem 'rspec-rails'
  gem 'spork'
  gem 'faker'
  gem "factory_girl_rails", ">= 4.0.0"
end

group :test do
  gem "capybara", ">= 1.1.2"
  gem "database_cleaner", ">= 0.8.0"
  gem "mongoid-rspec", ">= 1.4.6"
  gem "cucumber-rails", ">= 1.3.0"
  gem "launchy", ">= 2.1.2"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
