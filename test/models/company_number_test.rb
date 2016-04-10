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
#  app_id          :integer
#

require 'test_helper'

class CompanyNumberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
