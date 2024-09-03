
Rails.application.config.after_initialize do
    # Cual base se conecta
    db_config = ActiveRecord::Base.connection_db_config
    Rails.logger.info "Conectando a la base de datos: #{db_config.database} en #{db_config.host}:#{db_config.configuration_hash[:port]}"
end