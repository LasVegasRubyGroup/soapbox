# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:presenter] do
    name 'Example User'
    organizer false
    # email { Faker::Internet.email }
  end

  factory :organizer, parent: :user do
    organizer true
  end
end
