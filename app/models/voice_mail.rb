# == Schema Information
#
# Table name: voice_mails
#
#  id         :integer          not null, primary key
#  url        :string
#  duration   :integer
#  call_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VoiceMail < ActiveRecord::Base
  belongs_to :call
end
