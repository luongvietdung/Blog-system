# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name:  "Luong Viet Dung",
             email: "luong.viet.dung@framgia.com",
             password:              "123456",
             password_confirmation: "123456")

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create!(name: name,
              email: email,
              password:              password,
              password_confirmation: password)
end

# Microposts
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Name.title
  body = Faker::Lorem.sentence(60)
  users.each { |user| user.entries.create!(body: body, title: title) }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

entries = Entry.order(:created_at).take(10)
users = User.order(:created_at).take(6)
1.times do
  entries.each do |entry| 
    users.each do |user|
      content = Faker::Lorem.sentence(1)
      entry.comments.create!(content: content, user_id: user.id)
    end
    
  end
end
