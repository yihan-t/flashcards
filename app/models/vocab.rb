# == Schema Information
#
# Table name: vocabs
#
#  id         :integer          not null, primary key
#  lesson_id  :integer
#  english    :string
#  chinese    :string
#  notes      :string
#  e2c_w      :integer
#  e2c_l      :integer
#  c2e_w      :integer
#  c2e_l      :integer
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Vocab < ApplicationRecord
  validates :english,
    presence: true,
    uniqueness: {scope: :owner_id, message: "vocab word already exists"}
  validates :chinese,
    presence: true,
    uniqueness: {scope: :owner_id, message: "vocab word already exists"}
  validates :owner_id, presence: true
  
  belongs_to :lesson
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  
  before_save :downcase_vocab
  def downcase_vocab
    self.english = english.downcase
    self.chinese = chinese.downcase
  end
  
end
