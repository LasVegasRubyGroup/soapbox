DatabaseCleaner.orm = 'active_record'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

print 'Creating 10 users'
10.times do
  FactoryGirl.create(:user, email: Faker::Internet.email)
  print '.'
end
puts 'Done!'

print 'Creating 10 topics'
10.times do
  FactoryGirl.create(:topic, title: Faker::Lorem.sentence, description: Faker::Lorem.sentences.join(' '))
  print '.'
end
puts 'Done!'

topics = Topic.all

print 'Simulating votes'
User.all.each do |user|
  # Select a subset of topics and vote for them as each existing user
  topics.shuffle.slice(0..rand(topics.count)).each { |t| user.vote_on!(t) }
  print '.'
end
puts 'Done!'

print 'Simulating volunteers'
User.all.each do |user|
  # Select a subset of topics and volunteer for them as each existing user
  topics.shuffle.slice(0..rand(5)).each { |t| user.volunteer_for!(t) }
  print '.'
end
puts 'Done!'

User.create(email: 'user@example.com', password: 'test123',
            password_confirmation: 'test123', organizer: false)

User.create(email: 'organizer@example.com', password: 'test123',
            password_confirmation: 'test123', organizer: true)

puts <<-INFO
================================================================================
Congratulations! Your database is now filled with random data. You can sign in
 at http://localhost:5000/users/sign_in with the following details:

    Email address: user@example.com
         Password: test123

    Email address: organizer@example.com
         Password: test123
================================================================================
INFO
