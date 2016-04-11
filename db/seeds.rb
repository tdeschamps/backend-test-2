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

aviato = App.create(plivo_service.create_application(ENV.fetch('APP_URL'), FFaker::Company.name,).merge!({name: "Aviato", app_url: ENV.fetch('APP_URL')}))

users.each do |name|
  user = User.create(name: name, app_id: aviato.id)
  user.user_numbers << apps.map do |app|
    UserNumber.create(plivo_service.create_sip_endpoint("#{user.name}#{app.capitalize}", FFaker::Internet.password, aviato.app_id))
  end
end

lines.each_with_index do |line, index|
  aviato.company_numbers <<  CompanyNumber.create(plivo_service.create_sip_endpoint(line, FFaker::Internet.password, aviato.app_id))
end
