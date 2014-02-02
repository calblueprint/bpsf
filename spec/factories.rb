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

  factory :super_user do
    first_name 'SuperUser'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "super-#{n}@test.com" }
    password 'foobar'
  end

  factory :school do
    sequence(:name) { |n| "School #{n}" }
  end

  factory :grant do
    sequence(:title)           { |n| "Grant #{n}" }
    summary                    Faker::Lorem.sentence
    subject_areas              ["Art & Music", "Reading"]
    sequence(:grade_level)     { |n| "#{n % 8 + 2}" }
    sequence(:duration)        { |n| "#{n} weeks" }
    sequence(:num_classes)     { |n| n }
    sequence(:num_students)    { |n| n * 10 }
    sequence(:total_budget)    { |n| n * 200 }
    sequence(:requested_funds) { |n| n * 250 }
    funds_will_pay_for         ['Other']
    subject_areas              ['Other']
    budget_desc                Faker::Lorem.paragraph
    purpose                    Faker::Lorem.paragraph
    methods                    Faker::Lorem.paragraph
    background                 Faker::Lorem.paragraph
    sequence(:n_collaborators) { |n| n }
    collaborators              Faker::Lorem.paragraph
    comments                   Faker::Lorem.paragraph
    recipient
    school
  end

  factory :draft_grant do
    sequence(:title) { |n| "Grant #{n}" }
    recipient
    school

    factory :filled_in_draft_grant do
      summary                    Faker::Lorem.sentence
      subject_areas              ["Art & Music", "Reading"]
      sequence(:grade_level)     { |n| "#{n % 8 + 2}" }
      sequence(:duration)        { |n| "#{n} weeks" }
      sequence(:num_classes)     { |n| n }
      sequence(:num_students)    { |n| n * 10 }
      sequence(:total_budget)    { |n| n * 200 }
      sequence(:requested_funds) { |n| n * 250 }
      funds_will_pay_for         ['Other']
      subject_areas              ['Other']
      budget_desc                Faker::Lorem.paragraph
      purpose                    Faker::Lorem.paragraph
      methods                    Faker::Lorem.paragraph
      background                 Faker::Lorem.paragraph
      sequence(:n_collaborators) { |n| n }
      collaborators              Faker::Lorem.paragraph
      comments                   Faker::Lorem.paragraph
    end
  end

end