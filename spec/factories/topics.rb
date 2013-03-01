FactoryGirl.define do
  factory :topic do
    sequence(:title) { |n| "Topic #{n}" }
    description 'Lorem ipsum olor sit amet, consectetur adipiscing elit. Morbi id hendrerit orci. Fusce quis lacus purus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.'
    user

    factory :topic_with_votes do
      ignore do
        votes_count 10
      end

      after(:create) do |topic, evaluator|
        evaluator.votes_count.times do
          FactoryGirl.create(:user).vote_on!(topic)
        end
      end
    end
  end
end
