# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
rauru = User.create(email: 'r@gmail.com',
  password: '999999',
  password_confirmation: '999999',
  role: 'admin')
User.create(email: 'z@gmail.com',
password: '888888',
password_confirmation: '888888')
User.create(email: 'l@gmail.com',
password: '777777',
password_confirmation: '777777')
rauru.joined_rooms << Room.create(name: 'General', is_private: false)
rauru.joined_rooms << Room.create(name: 'Testing', is_private: false)