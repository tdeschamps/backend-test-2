# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  app_id     :integer
#

class User < ActiveRecord::Base
  validates :app_id, presence: true
  has_many :user_numbers
end
