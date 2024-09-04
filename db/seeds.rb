# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end




# CARGA INICIAL DE DATOS -> DESDE initializers se configura

# SE USA COMANDO -> "rails db:seed"

# Ejemplo
# User.create!([
#   { name: 'Juan Perez', email: 'juan.perez@example.com', password: 'password123' },
#   { name: 'Maria Gomez', email: 'maria.gomez@example.com', password: 'password456' },
#   { name: 'Carlos Diaz', email: 'carlos.diaz@example.com', password: 'password789' }
# ])

#
# Category.create!([
#   { name: 'Tecnología' },
#   { name: 'Salud' },
#   { name: 'Educación' }
# ])

#
# Product.create!([
#   { name: 'Laptop', price: 1000, category_id: Category.find_by(name: 'Tecnología').id },
#   { name: 'Medicamento', price: 50, category_id: Category.find_by(name: 'Salud').id },
#   { name: 'Libro', price: 30, category_id: Category.find_by(name: 'Educación').id }
# ])
