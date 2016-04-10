class Call < ActiveRecord::Base
  belongs_to :company_number
  belongs_to :user_number
end
