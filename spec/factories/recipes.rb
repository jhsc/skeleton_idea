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

FactoryGirl.define do
  factory :recipe do
    title "MyText"
content "MyText"
cool false
  end

end
