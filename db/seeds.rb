# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
users = %w(Jane Peter Luke)
lines = %w(main sales support)
apps = %w(phone desktop tablet)

plivo_service = PlivoService.new

users.each do |name|
  user = User.create(name: name)
  user.user_numbers << apps.map do |app|
    UserNumber.create(plivo_service.create_sip_endpoint(app, FFaker::Internet.password))
  end
end

lines.each do |line|
  CompanyNumber.create(plivo_service.create_sip_endpoint(line, FFaker::Internet.password))
end

aviato = App.create(plivo_service.create_application("localhost:3000", "Aviato").merge!({name: "Aviato"}))
