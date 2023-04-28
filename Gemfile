source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"


# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

#gem "tailwindcss-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "kaminari"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

gem 'rails-i18n'

gem 'carrierwave'

# Rails 5.2 and Rails 6
gem 'active_storage_validations'

# Optional, to use :dimension validator or :aspect_ratio validator
gem 'mini_magick', '>= 4.9.5'
# Or


# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem 'bootstrap'
gem 'font-awesome-sass', '~> 6.2.0'
gem 'fog-aws'
gem 'dotenv-rails'

gem 'enum_help'
# Use Sass to process CSS
gem "sassc-rails"

gem 'config'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2
gem 'ransack'
gem 'sorcery'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'letter_opener_web'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'faker'
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Use postgresql as the database for Active Record
  gem "pg", '1.2.3'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'sorcery'
  gem 'pry-byebug'
end



group :production do
  gem 'mysql2'
  gem 'unicorn'
  gem "aws-sdk-s3"
end