FactoryGirl.define do
  factory :meeting do
    date { Date.today }

    factory :meeting_with_time_slots do
      ignore do
        time_slots_count 3
      end

      after(:build) do |evaluator, meeting|
        evaluator.time_slots_count.times do
          meeting.time_slots << FactoryGirl.build(:time_slot)
        end
      end
    end
  end
end
