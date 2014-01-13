# Seed data for the app

def make_schools
  School.create! name: 'Arts Magnet Elementary School'
  School.create! name: 'Cragmont Elementary School'
  School.create! name: 'Emerson Elementary School'
  School.create! name: 'Jefferson Elementary School'
  School.create! name: 'John Muir Elementary School'
  School.create! name: 'LeConte Elementary School'
  School.create! name: 'Malcolm X Elementary School'
  School.create! name: 'Oxford Elementary School'
  School.create! name: 'Rosa Parks Elementary School'
  School.create! name: 'Thousand Oaks Elementary School'
  School.create! name: 'Washington Elementary School'
  School.create! name: 'King Middle Middle School'
  School.create! name: 'Longfellow Middle School'
  School.create! name: 'Willard Middle School'
  School.create! name: 'Franklin District Preschool'
  School.create! name: 'Hopkins District Preschool'
  School.create! name: 'King District Preschool'
  School.create! name: 'Berkeley High School - AC'
  School.create! name: 'Berkeley High School - AHA'
  School.create! name: 'Berkeley High School - CAS'
  School.create! name: 'Berkeley High School - CPA'
  School.create! name: 'Berkeley High School - GA'
  School.create! name: 'Berkeley High School - IB'
  School.create! name: 'Berkeley High School - All'
  School.create! name: 'B-Tech'
  School.create! name: 'Independent Study'
  School.create! name: 'Districtwide'
  School.create! name: 'Herrick Hospital'
  School.create! name: 'Other BUSD'
end

def make_users
  1.upto(2) do |n|
    SuperUser.create! first_name: "SuperUser #{n}",
                      last_name: "Dev",
                      email: "bpsfsuper#{n}@gmail.com",
                      password: "password",
                      password_confirmation: "password",
                      approved: true
  end
  1.upto(2) do |n|
    Admin.create! first_name: "Admin #{n}",
                  last_name: "Dev",
                  email: "bpsfadmin#{n}@gmail.com",
                  password: "password",
                  password_confirmation: "password",
                  approved: false
  end
  1.upto(10) do |n|
    Recipient.create! first_name: "Teacher #{n}",
                      last_name: "Dev",
                      email: "bpsfteacher#{n}@gmail.com",
                      password: "password",
                      password_confirmation: "password",
                      approved: true,
                      school_id: rand(1..School.count)
  end
  1.upto(8) do |n|
    User.create! first_name: "Parent #{n}",
                 last_name: "Dev",
                 email: "bpsfparent#{n}@gmail.com",
                 password: "password",
                 password_confirmation: "password",
                 approved: true
  end
  a = Admin.first
  a.approved = true ; a.save!
end

def make_profiles
  Recipient.all.each do |recipient|
    profile = RecipientProfile.create! recipient_id: recipient.id,
                                       school_id: recipient.school_id,
                                       about: Faker::Lorem.characters,
                                       started_teaching: 2.years.ago,
                                       subject: Faker::Lorem.sentence,
                                       grade: Faker::Lorem.sentence,
                                       address: Faker::Address.street_address,
                                       city: 'Berkeley',
                                       zipcode: 94720,
                                       work_phone: Faker::PhoneNumber.phone_number,
                                       home_phone: Faker::PhoneNumber.phone_number
    recipient.profile = profile
  end
  Admin.all.each do |admin|
    profile = AdminProfile.create! admin_id: admin.id,
                                   about: Faker::Lorem.sentence,
                                   position: Faker::Lorem.sentence
    admin.profile = profile
  end
  SuperUser.all.each do |user|
    profile = AdminProfile.create! admin_id: user.id,
                                   about: Faker::Lorem.sentence,
                                   position: Faker::Lorem.sentence
    user.profile = profile
  end
end

def make_grants
  crowdfunding_grants = []
  Recipient.all.each do |r|
    r.draft_grants.create! title: "Draft #{r.id}",
                           summary: Faker::Lorem.sentence,
                           subject_areas: ["Other"],
                           school_id: r.school_id
    crowdfunding_grants << r.grants.build(title: "Grant #{r.id-4}",
                                          summary: Faker::Lorem.sentence,
                                          subject_areas: ["Arts / Music", "Multi-subject"],
                                          grade_level: "#{rand(1..11)}",
                                          duration: "#{rand(1..4)} weeks",
                                          school_id: r.school_id,
                                          num_classes: rand(1..5),
                                          num_students: rand(1..5) * 10,
                                          total_budget: rand(8..12) * 100,
                                          requested_funds: rand(1..3) * 250,
                                          funds_will_pay_for: ["Supplies"],
                                          budget_desc: Faker::Lorem.paragraph,
                                          purpose: Faker::Lorem.paragraph,
                                          methods: Faker::Lorem.paragraph,
                                          background: Faker::Lorem.paragraph,
                                          n_collaborators: rand(1..4),
                                          collaborators: Faker::Lorem.paragraph,
                                          comments: Faker::Lorem.paragraph,
                                          image: File.open(File.join(Rails.root, "app/assets/images/default/Art and Music.jpg")))
  end
  crowdfunding_grants.map do |grant|
    grant.crowdfund
    Crowdfund.create deadline: Time.now,
                     pledged_total: 0,
                     grant_id: grant.id,
                     goal: grant.requested_funds
    grant.save!
  end
end

def make_preapproved
  grants = Grant.all[1..10]
  grants.map &:preapprove!
end

make_schools
make_users
make_profiles
make_grants
make_preapproved
