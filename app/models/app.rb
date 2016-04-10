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
#

class App < ActiveRecord::Base
end
