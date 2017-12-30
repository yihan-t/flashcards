# == Schema Information
#
# Table name: piles
#
#  id             :integer          not null, primary key
#  user_id        :string
#  vocab          :text
#  vocab_w        :text
#  vocab_l        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  translate      :string
#  vocab_priority :text
#

class Pile < ApplicationRecord
  serialize :vocab,Array
  serialize :vocab_w,Array
  serialize :vocab_l,Array
  serialize :vocab_priority,Array
  
  validates :translate,
    presence: true,
    inclusion: { in: %w(e2c c2e)}
  
end
