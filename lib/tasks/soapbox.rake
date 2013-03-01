namespace :soapbox do
  task tally_points: :environment do
    User.update_all(points: 0)
    Meeting.with_state(:closed).each do |meeting|
      meeting.give_points!
    end
  end
end
