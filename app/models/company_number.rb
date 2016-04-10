# == Schema Information
#
# Table name: company_numbers
#
#  id              :integer          not null, primary key
#  sip_endpoint    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sip_endpoint_id :string
#  password        :string
#

class CompanyNumber < ActiveRecord::Base
  validates :sip_endpoint, uniqueness: true
  has_many :user_numbers
  has_many :calls
end
