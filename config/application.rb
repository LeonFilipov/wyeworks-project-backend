require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WyerworksProjectBackend
  class Application < Rails::Application
    
    # Set Timezone
    config.time_zone = 'America/Montevideo'

    # Autoload and eager load settings for lib directory
    config.autoload_lib(ignore: %w[assets tasks])

    # Active Record configurations
    config.active_record.schema_format = :ruby
    config.active_record.belongs_to_required_by_default = true
    config.active_record.database_selector = { delay: 2.seconds }
    config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
    config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

    # Cache settings
    config.cache_classes = true
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.active_record.cache_versioning = false

    # Active Storage configurations
    config.active_storage.service = :local
    config.active_storage.web_image_content_types = %w[image/png image/jpeg image/gif image/webp]

    # Middleware and security settings
    config.middleware.use Rack::Attack
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    # Enforce SSL for security
    config.force_ssl = true

    # Set SameSite policy for cookies to prevent CSRF attacks
    config.action_dispatch.cookies_same_site_protection = :strict

    # Protect from forgery
    config.action_controller.default_protect_from_forgery = true

    # Filter sensitive parameters from logs
    config.filter_parameters += [:password, :credit_card_number]

    # Logging and monitoring
    config.log_level = :info
    config.log_tags = [:request_id]
    config.active_support.deprecation = :notify

    # Configure Active Job
    config.active_job.queue_adapter = :sidekiq
    config.active_job.enqueue_after_transaction_commit = :default

    # Postgresql adapter configurations
    config.active_record.postgresql_adapter_decode_dates = true
    config.active_record.validate_migration_timestamps = true

    # YJIT configuration for performance (Ruby 3.1+)
    config.yjit = true

    # Asset pipeline configurations removed for API-only apps
  end
end
