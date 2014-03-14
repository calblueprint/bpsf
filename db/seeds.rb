# Seed data for the app
SEEDS = YAML.load(File.read(File.expand_path('../seeds.yml', __FILE__)))

def make_schools
  SEEDS[:schools].each do |school|
    School.create! school
  end
end

def make_users
  SuperUser.create! first_name: "Schools Fund",
                    last_name: "Admin",
                    email: "schoolsfund@berkeley.net",
                    password: "password",
                    password_confirmation: "password",
                    approved: true
  SuperUser.create! first_name: "Erin",
                    last_name: "Rhoades",
                    email: "erinrhoades@berkeley.net",
                    password: "password",
                    password_confirmation: "password",
                    approved: true
  SuperUser.create! first_name: "Laura",
                    last_name: "Brewer",
                    email: "laurabrewer@berkeley.net",
                    password: "password",
                    password_confirmation: "password",
                    approved: true
  SuperUser.create! first_name: "Wonjun",
                    last_name: "Jeong",
                    email: "jeong.wonjun@gmail.com",
                    password: "password",
                    password_confirmation: "password",
                    approved: true
end

def make_profiles
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
                                          requested_funds: rand(1..3) * 250,
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
                     goal: grant.requested_funds
    grant.save!

make_schools
make_users
make_profiles
