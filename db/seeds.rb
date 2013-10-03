# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Teachers (we refer to them as Recipients)
teacher1 = Recipient.create!(:name => "John Keating",
                             :email => "captain@whitman.com",
                             :password => "password",
                             :password_confirmation => "password")

teacher2 = Recipient.create!(:name => "Severus Snape",
                             :email => "severusandlily007@gmail.com",
                             :password => "password",
                             :password_confirmation => "password")

# Create Admins
admin1 = Admin.create!(:name => "Brian Wong",
                       :email => "brianderp@coolguys.org",
                       :password => "password",
                       :password_confirmation => "password")

admin2 = Admin.create!(:name => "Maurise Moss",
                       :email => "moss@itcrowd.com",
                       :password => "password",
                       :password_confirmation => "password")

# Create Parents (they are general Users)
parent1 = User.create!(:name => "Homer J Simpson",
                       :email => "chunkylover53@aol.com",
                       :password => "password",
                       :password => "password")

parent2 = User.create!(:name => "Heathcliff Huxtable",
                       :email => "zipzopzoobitybop@cosby.com",
                       :password => "password",
                       :password => "password")


