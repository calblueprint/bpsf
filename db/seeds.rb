# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Teachers (we refer to them as Recipients)
def make_users
  1.upto(2) do |n|
    SuperUser.create! first_name: "SuperUser #{n}",
                      last_name: "Dev",
                      email: "bpsfsuper#{n}@gmail.com",
                      password: "password",
                      password_confirmation: "password"
    Admin.create! first_name: "Admin #{n}",
                  last_name: "Dev",
                  email: "bpsfadmin#{n}@gmail.com",
                  password: "password",
                  password_confirmation: "password"
    Recipient.create! first_name: "Teacher #{n}",
                      last_name: "Dev",
                      email: "bpsfteacher#{n}@gmail.com",
                      password: "password",
                      password_confirmation: "password"
    User.create! first_name: "Parent #{n}",
                 last_name: "Dev",
                 email: "bpsfparent#{n}@gmail.com",
                 password: "password",
                 password_confirmation: "password"
  end
end

def make_profiles
  Recipient.all.each do |recipient|
    profile = RecipientProfile.create! recipient_id: recipient.id,
                                       about: Faker::Lorem.sentence,
                                       subject: Faker::Lorem.sentence,
                                       grade: Faker::Lorem.sentence
    recipient.recipient_profile = profile
  end
  Admin.all.each do |admin|
    profile = AdminProfile.create! admin_id: admin.id,
                                   about: Faker::Lorem.sentence,
                                   position: Faker::Lorem.sentence
    admin.admin_profile = profile
  end
end

def make_schools
  School.create! name: 'Berkeley High School'
  School.create! name: 'Washington Elementary School'
  School.create! name: 'Maybeck High School'
end

def make_grants
  t1 = Recipient.find_by_first_name 'Teacher 1'
  t2 = Recipient.find_by_first_name 'Teacher 2'
  1.upto(3) do |n|
    t1.draft_grants.create! title: "Draft #{n}",
                            summary: Faker::Lorem.sentence,
                            subject_areas: ["Other"]
    t2.draft_grants.create! title: "Draft #{n + 3}",
                            summary: Faker::Lorem.sentence,
                            subject_areas: ["Other"]
  end
  crowdfunding_grants = []
  1.upto(3) do |n|
    crowdfunding_grants << t1.grants.build(title: "Grant #{n}",
                                           summary: Faker::Lorem.sentence,
                                           subject_areas: ["Art & Music", "Reading"],
                                           grade_level: "#{n + 2}",
                                           duration: "#{n} weeks",
                                           num_classes: n,
                                           num_students: n * 10,
                                           total_budget: n * 300,
                                           requested_funds: n * 250,
                                           funds_will_pay_for: Faker::Lorem.paragraph,
                                           budget_desc: Faker::Lorem.paragraph,
                                           purpose: Faker::Lorem.paragraph,
                                           methods: Faker::Lorem.paragraph,
                                           background: Faker::Lorem.paragraph,
                                           n_collaborators: n,
                                           collaborators: Faker::Lorem.paragraph,
                                           comments: Faker::Lorem.paragraph)
    crowdfunding_grants << t2.grants.build(title: "Grant #{n + 3}",
                                           summary: Faker::Lorem.sentence,
                                           subject_areas: ["Field Trips"],
                                           grade_level: "#{n + 2}",
                                           duration: "#{n} weeks",
                                           num_classes: n,
                                           num_students: n * 10,
                                           total_budget: n * 300,
                                           requested_funds: n * 250,
                                           funds_will_pay_for: Faker::Lorem.paragraph,
                                           budget_desc: Faker::Lorem.paragraph,
                                           purpose: Faker::Lorem.paragraph,
                                           methods: Faker::Lorem.paragraph,
                                           background: Faker::Lorem.paragraph,
                                           n_collaborators: n,
                                           collaborators: Faker::Lorem.paragraph,
                                           comments: Faker::Lorem.paragraph)
  end
  crowdfunding_grants.map { |grant| grant.crowdfund ; grant.save! }
end

make_users
make_profiles
make_schools
make_grants
