# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Teachers (we refer to them as Recipients)
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

teacher1.grants.create! title: "Grant 1"
teacher2.grants.create! title: "Grant 2"
crowdfunding_grants = []
crowdfunding_grants << teacher1.grants.create!(title: "Crowdfunding 1")
crowdfunding_grants << teacher2.grants.create!(title: "Crowdfunding 2")
crowdfunding_grants << teacher1.grants.create!(title: "Crowdfunding 3")
crowdfunding_grants << teacher2.grants.create!(title: "Crowdfunding 4")
crowdfunding_grants << teacher1.grants.create!(title: "Crowdfunding 5")
crowdfunding_grants << teacher2.grants.create!(title: "Crowdfunding 6")
crowdfunding_grants.map { |grant| grant.crowdfund }
