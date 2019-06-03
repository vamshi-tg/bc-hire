# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n|
    name = Faker::Name.name
    email = "example-#{n}@gmail.com"
    experience = rand 1..12
    Candidate.create!(
        name: name,
        email: email,
        experience: experience)  
end
