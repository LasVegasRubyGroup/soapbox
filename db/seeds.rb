DatabaseCleaner.orm = 'active_record'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

meeting = Meeting.create(date: Date.current)
# FactoryGirl.create(:topic, :title => "Topic 2", :description => "This is a topic", meeting_id: meeting.id) 
# FactoryGirl.create(:topic, :title => "Topic 3", :description => "This is a topic", meeting_id: meeting.id)
#meeting.save

[
  { starts_at: '6:20 PM', ends_at: '6:50 PM' },
  { starts_at: '6:50 PM', ends_at: '7:20 PM' },
  { starts_at: '7:20 PM', ends_at: '7:50 PM' }
].each do |time_slot_starter|
  time_slot = meeting.time_slots.build(time_slot_starter)
  time_slot.topic = FactoryGirl.create(:topic, title: Faker::Lorem.sentence, description: "This is a topic", meeting_id: meeting.id, state: 'open')
  time_slot.presenter = FactoryGirl.create(:user)
  time_slot.save
end

print 'Creating 10 users'
10.times do
  FactoryGirl.create(:user)
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


print 'Simulating kudos'
  FactoryGirl.create_list(:kudo, 25)
puts 'Done!'


print 'Simulating volunteers'
User.all.each do |user|
  # Select a subset of topics and volunteer for them as each existing user
  topics.shuffle.slice(0..rand(5)).each { |t| user.volunteer_for!(t) }
  print '.'
end
puts 'Done!'



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
