# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  name       :string
#  app_id     :string
#  api_id     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  app_url    :string
#

class App < ActiveRecord::Base
  has_many :users
  has_many :user_numbers, through: :users
  has_many :company_numbers
  has_many :calls, through: :company_numbers

end
