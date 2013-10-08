# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Teachers (we refer to them as Recipients)
teacher1 = Recipient.create! first_name: 'John',
                             last_name: 'Keating',
                             email: 'captain@whitman.com',
                             password: 'password',
                             password_confirmation: 'password'

teacher2 = Recipient.create! first_name: 'Severus',
                             last_name: 'Snape',
                             email: 'severusandlily007@gmail.com',
                             password: 'password',
                             password_confirmation: 'password'

# Create Admins
admin1 = Admin.create! first_name: 'Brian',
                       last_name: 'Wong',
                       email: 'brianderp@coolguys.org',
                       password: 'password',
                       password_confirmation: 'password'

admin2 = Admin.create! first_name: 'Maurise',
                       last_name: 'Moss',
                       email: 'moss@itcrowd.com',
                       password: 'password',
                       password_confirmation: 'password'

# Create Parents (they are general Users)
parent1 = User.create! first_name: 'Homer J',
                       last_name: 'Simpson',
                       email: 'chunkylover53@aol.com',
                       password: 'password',
                       password: 'password'

parent2 = User.create! first_name: 'Heathcliff',
                       last_name: 'Huxtable',
                       email: 'zipzopzoobitybop@cosby.com',
                       password: 'password',
                       password: 'password'

teacher1.grants.create! title: "Grant 1"
teacher2.grants.create! title: "Grant 2"
g = teacher1.grants.create! title: "Crowdfunding Grant 1"
g.toggle! :crowdfunding
