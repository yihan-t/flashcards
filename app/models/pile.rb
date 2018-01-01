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
  
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  
  def self.record_win_to_pile(pile_id, vocab_id)
    @pile = Pile.find(pile_id)
    @vocab = Vocab.find(vocab_id)
    
    @pile_vocab_priority = @pile.vocab_priority
    @pile_vocab = @pile.vocab
   
    #Record win in vocab_w
    pile_vocab_w = @pile.vocab_w << @vocab.id
    @pile.vocab_w = pile_vocab_w

    ### Update cardpile
    ## If in priority, remove from priority
    if @pile_vocab_priority.include?(@vocab.id) == true
      @pile_vocab_priority.delete_at(@pile_vocab_priority.index(@vocab.id))
      @pile.vocab_priority = @pile_vocab_priority
    
    elsif @pile_vocab.include?(@vocab.id) == true ## Else remove from main list
      @pile_vocab.delete_at(@pile_vocab.index(@vocab.id))
      @pile.vocab = @pile_vocab
    end

    @pile.save 
  end
  
  def self.record_loss_to_pile(pile_id, vocab_id)
    
    @pile = Pile.find(pile_id)
    @vocab = Vocab.find(vocab_id)
    
    @pile_vocab_priority = @pile.vocab_priority
    @pile_vocab = @pile.vocab
   
    pile_vocab_l = @pile.vocab_l << @vocab.id
    @pile.vocab_l = pile_vocab_l
    
    ## Add card to priority list
    @pile.vocab_priority = @pile_vocab_priority.push(@vocab.id) 
    
    ## Add card to main list
    @pile.vocab = @pile_vocab.push(@vocab.id) 
    
    @pile.save
  end
  
  
end
