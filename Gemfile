source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.0"

gem "nokogiri", ">= 1.8.5"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4.2"

# For Cross-Origin Resource Sharing (CORS) support
gem "rack-cors", "~> 2.0", ">= 2.0.2"

# To manage environment variables
gem "dotenv-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
#
gem "sidekiq", "~> 7.1", ">= 7.1.2"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"
# Gem for http requests
gem "httparty"
# Gem for JWT service
gem "jwt"
# For use of UUIDs in the database
gem "pgcrypto"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Protection against abusive requests
gem "rack-attack"

# Profiling tools
# gem "rack-mini-profiler", "~> 2.0"

# Secured password handling
gem "bcrypt", "~> 3.1.7"

# gem "devise"

gem "pundit"

# Consistencia testing
gem "faker", "~> 1.6", ">= 1.6.6"

group :development, :test do
  # Debugging tools
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rubocop", require: false

  # Test suite gem
  gem "rspec-rails", "~> 7.0"

  # Factories for testing
  gem "factory_bot_rails"

  # Audit for vulnerable dependencies
  gem "bundler-audit", require: false

  # Preload application to speed up development tasks
  gem "spring"
end
