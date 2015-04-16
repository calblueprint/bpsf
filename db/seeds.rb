def check_env
  if Rails.env.production?
    exit
  end
end

# Do not seed if production environment
check_env

# Seed data for the app
SEEDS = YAML.load(File.read(File.expand_path('../seeds.yml', __FILE__)))

def make_schools
  SEEDS[:schools].each do |school|
    School.create! school
  end
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
                      approved: true
  end
  1.upto(8) do |n|
    User.create! first_name: "Parent #{n}",
                 last_name: "Dev",
                 email: "bpsfparent#{n}@gmail.com",
                 password: "password",
                 password_confirmation: "password",
                 approved: true,
                 type: "User"
  end
  a = Admin.first
  a.approved = true ; a.save!
end

def make_profiles
  User.donors.each do |user|
    user.create_profile! address: Faker::Address.street_address,
                         city: 'Berkeley',
                         zipcode: 94720,
                         phone: Faker::PhoneNumber.phone_number,
                         relationship: 'Alum'
  end
  Recipient.all.each do |recipient|
    recipient.create_profile! school_id: rand(1..School.count),
                              about: Faker::Lorem.sentence,
                              started_teaching: 2.years.ago,
                              subject: Faker::Lorem.sentence,
                              grade: Faker::Lorem.sentence,
                              address: Faker::Address.street_address,
                              city: 'Berkeley',
                              state: 'CA',
                              zipcode: 94720,
                              work_phone: Faker::PhoneNumber.phone_number,
                              home_phone: Faker::PhoneNumber.phone_number
  end
  Admin.all.each do |admin|
    admin.create_profile! about: Faker::Lorem.sentence,
                          position: Faker::Lorem.sentence
  end
  SuperUser.all.each do |user|
    user.create_profile! about: Faker::Lorem.sentence,
                         position: Faker::Lorem.sentence
  end
end

def make_grants
  crowdfunding_grants = []
  Recipient.all.each do |r|
    r.draft_grants.create!  title: "Draft #{r.id}",
                            summary: Faker::Lorem.sentence,
                            subject_areas: ["Other"],
                            school_id: r.profile.school_id
    crowdfunding_grants << r.grants.build(title: "Grant #{r.id-4}",
                                          deadline: 30.days.from_now,
                                          summary: Faker::Lorem.sentence,
                                          subject_areas: ["Arts / Music", "Multi-subject"],
                                          grade_level: "#{rand(1..11)}",
                                          duration: "#{rand(1..4)} weeks",
                                          school_id: r.profile.school_id,
                                          num_classes: rand(1..5),
                                          num_students: rand(1..5) * 10,
                                          total_budget: rand(8..12) * 100,
                                          funds_will_pay_for: ["Supplies"],
                                          budget_desc: Faker::Lorem.paragraph,
                                          purpose: Faker::Lorem.paragraph,
                                          methods: Faker::Lorem.paragraph,
                                          background: Faker::Lorem.paragraph,
                                          n_collaborators: rand(1..4),
                                          collaborators: Faker::Lorem.paragraph,
                                          comments: Faker::Lorem.paragraph,
                                          image: File.open(File.join(Rails.root, "app/assets/images/default/Other.jpg")))
  end
  crowdfunding_grants.map do |grant|
    grant.crowdfund
    Crowdfund.create pledged_total: rand(1..3) * 150,
                     grant_id: grant.id,
                     goal: grant.with_admin_cost
    grant.save!
  end
end

def make_grants
  crowdfunding_grants = []
  Recipient.all.each do |r|
    r.draft_grants.create!  title: "Draft #{r.id}",
                            summary: Faker::Lorem.sentence,
                            subject_areas: ["Other"],
                            school_id: r.profile.school_id
    crowdfunding_grants << r.grants.build(title: "Grant #{r.id-4}",
                                          deadline: 30.days.from_now,
                                          summary: Faker::Lorem.sentence,
                                          subject_areas: ["Arts / Music", "Multi-subject"],
                                          grade_level: "#{rand(1..11)}",
                                          duration: "#{rand(1..4)} weeks",
                                          school_id: r.profile.school_id,
                                          num_classes: rand(1..5),
                                          num_students: rand(1..5) * 10,
                                          total_budget: rand(8..12) * 100,
                                          funds_will_pay_for: ["Supplies"],
                                          budget_desc: Faker::Lorem.paragraph,
                                          purpose: Faker::Lorem.paragraph,
                                          methods: Faker::Lorem.paragraph,
                                          background: Faker::Lorem.paragraph,
                                          n_collaborators: rand(1..4),
                                          collaborators: Faker::Lorem.paragraph,
                                          comments: Faker::Lorem.paragraph,
                                          image: File.open(File.join(Rails.root, "app/assets/images/default/Other.jpg")))
  end
  crowdfunding_grants.map do |grant|
    grant.crowdfund
    Crowdfund.create pledged_total: rand(1..3) * 150,
                     grant_id: grant.id,
                     goal: grant.total_budget
    grant.save!
  end
end

make_schools
make_users
make_profiles
make_grants
