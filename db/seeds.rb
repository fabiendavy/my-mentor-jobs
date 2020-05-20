# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'

file = "data.json"
data = JSON.parse(File.read(file))

data["fields"].each do |field|
  Field.create!(name: field["name"])
end
puts "Fields created from data.json"

data["levels"].each do |field|
  Level.create!(grade: field["grade"], cycle: field["cycle"])
end
puts "Levels created data.json"
