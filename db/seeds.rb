require 'faker'
require_relative 'helpers/state_seeder'
include StateSeeder

Item.destroy_all
Category.destroy_all
User.destroy_all
State.destroy_all
City.destroy_all
Address.destroy_all
Order.destroy_all

puts "Creating categories"
10.times do
  Category.create(name: Faker::Coffee.unique.variety)
end
puts "#{Category.all.count} Categories created"

puts "Gathering Image Urls"
images = (1..27).collect { |n| "#{n}.png" }
puts "Gathered #{images.count} Image Urls"

puts "Creating Items"
27.times.map do |i|
  Item.create!( name:         Faker::Coffee.unique.blend_name,
                description:  "#{Faker::Coffee.notes}",
                categories:   Category.all.shuffle.take(rand(1..3)),
                price:        rand(10.00..1000.00).round(2),
                tax_rate:     rand(0.00..50.00).round(2),
                status:       0,
                photo:        File.open("app/assets/images/coffee/#{images[i]}"))

  puts "Item #{Item.last.name} created. (#{i})"
end

def grab_items
  items = []
  rand(1..10).times do
    item = Item.all.sample
    if rand(1..10) == 5
      rand(1..5).times { items << item }
    else
      items << item
    end
  end
  items
end

puts "Created #{Item.count} items"

puts "Creating Admin"
admin = User.create(email: 'admin@admin.com', first_name: 'Madman', last_name: 'Max', password: 'password', role: 'admin')
puts "Created Admin #{User.find_by(role: 'admin').first_name}"

puts "Creating Users"
users = 100.times.map { |i| User.create(email: "#{i}user", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: 'password') }
puts "Created #{User.count} Users"

puts "Creating States"
states = StateSeeder.all_states.map { |state| State.create(name: state.name, abbr: state.abbr) }
puts "Created #{State.count} states"

puts "Creating Cities"
cities = 100.times.map { City.create(name: Faker::Address.city, state: State.all.sample) }
puts "Created #{City.count} Cities"

puts "Creating Addresses"
addresses = 100.times.map { Address.create(address: Faker::Address.street_address, zipcode: Faker::Address.zip, city: cities.sample) }
puts "Created #{Address.count} Addresses"

puts "Creating Orders"
350.times { Order.create(address: addresses.sample, items: grab_items, status: rand(0..3), user: users.sample) }
puts "Created #{Order.count} Orders"
