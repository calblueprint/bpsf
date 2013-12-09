# Seed data for the app

def make_schools
  School.create! name: 'Berkeley High School'
  School.create! name: 'Washington Elementary School'
  School.create! name: 'Maybeck High School'
  School.create! name: 'Whitney High School'
end

# Create Teachers (we refer to them as Recipients)
def make_users
  1.upto(2) do |n|
    SuperUser.create! first_name: "SuperUser #{n}",
                      last_name: "Dev",
                      email: "bpsfsuper#{n}@gmail.com",
                      password: "password",
                      password_confirmation: "password",
                      approved: true
    Admin.create! first_name: "Admin #{n}",
                  last_name: "Dev",
                  email: "bpsfadmin#{n}@gmail.com",
                  password: "password",
                  password_confirmation: "password",
                  approved: false
    Recipient.create! first_name: "Teacher #{n}",
                      last_name: "Dev",
                      email: "bpsfteacher#{n}@gmail.com",
                      password: "password",
                      password_confirmation: "password",
                      approved: true,
                      school_id: n
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
                                       about: Faker::Lorem.sentence,
                                       subject: Faker::Lorem.sentence,
                                       grade: Faker::Lorem.sentence
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
  t1 = Recipient.find_by_first_name 'Teacher 1'
  t2 = Recipient.find_by_first_name 'Teacher 2'
  1.upto(3) do |n|
    t1.draft_grants.create! title: "Draft #{n}",
                            summary: Faker::Lorem.sentence,
                            subject_areas: ["Other"],
                            school_id: t1.school_id
    t2.draft_grants.create! title: "Draft #{n + 3}",
                            summary: Faker::Lorem.sentence,
                            subject_areas: ["Other"],
                            school_id: t2.school_id
  end
  crowdfunding_grants = []
  1.upto(4) do |n|
    crowdfunding_grants << t1.grants.build(title: "Grant #{n}",
                                           summary: Faker::Lorem.sentence,
                                           subject_areas: ["Arts / Music", "Multi-subject"],
                                           grade_level: "#{n + 2}",
                                           duration: "#{n} weeks",
                                           school_id: t1.school_id,
                                           num_classes: n,
                                           num_students: n * 10,
                                           total_budget: n * 300,
                                           requested_funds: n * 250,
                                           funds_will_pay_for: "Supplies",
                                           budget_desc: Faker::Lorem.paragraph,
                                           purpose: Faker::Lorem.paragraph,
                                           methods: Faker::Lorem.paragraph,
                                           background: Faker::Lorem.paragraph,
                                           n_collaborators: n,
                                           collaborators: Faker::Lorem.paragraph,
                                           comments: Faker::Lorem.paragraph)
    crowdfunding_grants << t2.grants.build(title: "Grant #{n + 4}",
                                           summary: Faker::Lorem.sentence,
                                           subject_areas: ["Mathematics"],
                                           grade_level: "#{n + 2}",
                                           duration: "#{n} weeks",
                                           school_id: t2.school_id,
                                           num_classes: n,
                                           num_students: n * 10,
                                           total_budget: n * 300,
                                           requested_funds: n * 250,
                                           funds_will_pay_for: "Equipment",
                                           budget_desc: Faker::Lorem.paragraph,
                                           purpose: Faker::Lorem.paragraph,
                                           methods: Faker::Lorem.paragraph,
                                           background: Faker::Lorem.paragraph,
                                           n_collaborators: n,
                                           collaborators: Faker::Lorem.paragraph,
                                           comments: Faker::Lorem.paragraph)
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
  g = Grant.first
  g.preapprove!
end

make_schools
make_users
make_profiles
make_grants
make_preapproved
