# Load the Rails application.
require_relative "application"

# Custom initialization code
Rails.application.config.before_initialize do
  puts "Running custom environment configurations..."

  # Variables de entorno
  # ENV["SOME_GLOBAL_CONFIG"] ||= "default_value"
  # Ejemplo de uso:
  # some_config = ENV["SOME_GLOBAL_CONFIG"]


  # Estas variables deben de estar definidas en otro lado.
  # ENV["DB_PROD_HOST"] ||= "localhost"
  # ENV["DB_PROD_PORT"] ||= "5432"
  # ENV["DB_PROD_USERNAME"] ||= "postgres"
  # ENV["DB_PROD_PASSWORD"] ||= "password"
  # ENV["DB_PROD_NAME"] ||= "tutorias_production"

  # Custom logging configuration
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.level = Logger::DEBUG if Rails.env.development?

  # Ejemplos de uso
  # Rails.logger.debug "Este es un mensaje de depuración"
  # Rails.logger.info "Este es un mensaje informativo"
  # Rails.logger.warn "Este es un mensaje de advertencia"
  # Rails.logger.error "Este es un mensaje de error"
  # Rails.logger.fatal "Este es un mensaje fatal"


  # Example of loading environment-specific settings or secrets (using Rails credentials)
  #   if Rails.env.production?
  #     Rails.application.config.some_production_setting = Rails.application.credentials.dig(:production, :some_setting)
  #   end
end

# Initialize the Rails application.
Rails.application.initialize!
