FactoryGirl.define do

  factory :user do
    first_name 'User'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "user-#{n}@test.com" }
    password 'foobar'
  end

  factory :recipient do
    first_name 'Recipient'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "recipient-#{n}@test.com" }
    password 'foobar'
  end

  factory :admin do
    first_name 'Admin'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "admin-#{n}@test.com" }
    password 'foobar'
  end

  factory :grant do
    sequence(:title) { |n| "Grant #{n}" }
    recipient
  end

  factory :draft_grant do
    sequence(:title) { |n| "Grant #{n}" }
    recipient
  end

end