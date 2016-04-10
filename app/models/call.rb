# == Schema Information
#
# Table name: calls
#
#  id                :integer          not null, primary key
#  uuid              :string
#  caller_id         :string
#  caller_name       :string
#  status            :string
#  company_number_id :integer
#  user_number_id    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  hangup_case       :string
#  start_time        :datetime
#  end_time          :datetime
#  answer_time       :datetime
#

class Call < ActiveRecord::Base
  belongs_to :company_number
  belongs_to :user_number
  has_one :voice_mail
end
