# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:presenter] do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'p@ssw0rd!'
    password_confirmation { password }
    name 'Example User'
    organizer false
  end

  factory :organizer, parent: :user do
    organizer true
  end
end
