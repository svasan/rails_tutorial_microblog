# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "Test User",
             email: "test@user.com",
             password: "qwert1234",
             password_confirmation: "qwert1234",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password#{n+1}"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(7)
users.each do |user|
  25.times do
    quote = Faker::Shakespeare.hamlet_quote.truncate(140)
    user.microposts.create!(content: quote)

    quote = Faker::Shakespeare.as_you_like_it_quote.truncate(140)
    user.microposts.create!(content: quote)

    quote = Faker::Shakespeare.king_richard_iii_quote.truncate(140)
    user.microposts.create!(content: quote)

    quote = Faker::Shakespeare.romeo_and_juliet_quote.truncate(140)
    user.microposts.create!(content: quote)
  end
end


users = User.all
first = User.first
following = users[2..50]
followers = users[3..40]
following.each { |f| first.follow(f) }
followers.each { |f| f.follow(first) }
