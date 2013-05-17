
FactoryGirl.define do
  factory :kudo do
    sequence :user_id do |n|
      n
    end
    topic_id { rand(1..3) }
  end
end
