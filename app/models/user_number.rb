# == Schema Information
#
# Table name: user_numbers
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  sip_endpoint    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sip_endpoint_id :string
#  password        :string
#

class UserNumber < ActiveRecord::Base
  belongs_to :user
end
