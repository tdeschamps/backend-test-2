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

aviato = App.create(plivo_service.create_application("localhost:3000", "Aviato").merge!({name: "Aviato"}))

users.each do |name|
  user = User.create(name: name)
  user.user_numbers << apps.map do |app|
    UserNumber.create(plivo_service.create_sip_endpoint(app, FFaker::Internet.password))
  end
  aviato.user_numbers << user.user_numbers
end

lines.each do |line|
  aviato.user_numbers << CompanyNumber.create(plivo_service.create_sip_endpoint(line, FFaker::Internet.password))
end
