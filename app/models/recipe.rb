# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  cool       :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Recipe < ActiveRecord::Base
end
