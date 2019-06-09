# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Candidates
50.times do |n|
    name = Faker::Name.name
    email = "example-#{n}@gmail.com"
    Candidate.create!(
        name: name,
        email: email)  
end

# Candidates Application
candidates = Candidate.order(:created_at).take(30)
roles = ["Full Stack Developer", "Web Developer", "Graphic Designer"]
candidates.each do|candidate| 
    role = roles[rand 0..2]
    experience = rand 1..10
    candidate.applications.create!(role: role, experience: experience) 
end

# Employee
5.times do |n|
    name = Faker::Name.name
    role = "Interviewer"
    Employee.create!(name: name, role: role)
end