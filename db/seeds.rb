# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data so we can run this multiple times cleanly
User.destroy_all

# Create one user of each role
customer = User.create!(
  email: 'customer@test.com',
  password: 'password123',
  role: 'customer'
)

workshop = User.create!(
  email: 'workshop@test.com',
  password: 'password123',
  role: 'workshop'
)

admin = User.create!(
  email: 'admin@test.com',
  password: 'password123',
  role: 'admin'
)

puts "✅ Created users:"
puts "   Customer  → #{customer.email}"
puts "   Workshop  → #{workshop.email}"
puts "   Admin     → #{admin.email}"