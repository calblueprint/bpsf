# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Teachers (we refer to them as Recipients)
def make_users
  teacher1 = Recipient.create! first_name: 'Teacher_1',
                               last_name: 'Dev',
                               email: 'bpsfteacher1@gmail.com',
                               password: 'password',
                               password_confirmation: 'password'

  teacher2 = Recipient.create! first_name: 'Teacher_2',
                               last_name: 'Dev',
                               email: 'bpsfteacher2@gmail.com',
                               password: 'password',
                               password_confirmation: 'password'

  # Create Admins
  admin1 = Admin.create! first_name: 'Admin_1',
                         last_name: 'Dev',
                         email: 'bpsfadmin1@gmail.com',
                         password: 'password',
                         password_confirmation: 'password'

  admin2 = Admin.create! first_name: 'Admin_2',
                         last_name: 'Dev',
                         email: 'bpsfadmin2@gmail.com',
                         password: 'password',
                         password_confirmation: 'password'

  # Create Parents (they are general Users)
  parent1 = User.create! first_name: 'Parent_1',
                         last_name: 'Dev',
                         email: 'bpsfparent1@gmail.com',
                         password: 'password',
                         password_confirmation: 'password'

  parent2 = User.create! first_name: 'Parent_2',
                         last_name: 'Dev',
                         email: 'bpsfparent2@gmail.com',
                         password: 'password',
                         password_confirmation: 'password'
end

def make_schools
  School.create! name: 'Berkeley High School'
  School.create! name: 'Washington Elementary School'
  School.create! name: 'Maybeck High School'
end

def make_grants
  t1 = Recipient.find_by_first_name 'Teacher_1'
  t2 = Recipient.find_by_first_name 'Teacher_2'
  3.times do |n|
    t1.draft_grants.create! title: "Draft #{n}",
                            summary: Faker::Lorem.sentence
    t2.draft_grants.create! title: "Draft #{n + 3}",
                            summary: Faker::Lorem.sentence
  end
  crowdfunding_grants = []
  3.times do |n|
    crowdfunding_grants << t1.grants.build(title: "Grant #{n}",
                                           summary: Faker::Lorem.sentence,
                                           subject_areas: 'Art Science',
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
                                           subject_areas: 'Art Science',
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
make_schools
make_grants