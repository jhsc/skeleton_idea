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

require 'rails_helper'

RSpec.describe Recipe, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
