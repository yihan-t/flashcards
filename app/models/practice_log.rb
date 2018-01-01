# == Schema Information
#
# Table name: practice_logs
#
#  id            :integer          not null, primary key
#  vocab_id      :integer
#  pile_id       :integer
#  practice_type :string
#  win           :integer
#  loss          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :string
#

class PracticeLog < ApplicationRecord
  validates :vocab_id, presence: true
  validates :pile_id, presence: true
  validates :practice_type, presence: true, inclusion: { in: %w(e2c c2e)}
  
  def self.record_practice_to_log(pile_id, vocab_id, wl)
    @record = PracticeLog.new
    
    @record.vocab_id = vocab_id
    @record.pile_id = pile_id
    
    @record.practice_type = Pile.find(pile_id).translate
    @record.user_id = Pile.find(pile_id).user_id
    
    if wl == "win"
      @record.win=1  
    elsif wl == "loss"
      @record.loss=2
    end
    
    @record.save
    
  end
    
end
