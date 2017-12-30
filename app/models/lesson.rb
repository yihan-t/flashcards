# == Schema Information
#
# Table name: lessons
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#

class Lesson < ApplicationRecord
  validates :name, 
    presence: true,
    uniqueness: {scope: :owner_id, message: "of lesson already exists"}
  validates :owner_id, presence: true
  
  has_many :vocabs
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
end
