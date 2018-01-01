class PilesController < ApplicationController
  def choose_practice
    render("piles/choosepractice.html.erb")
  end
  
  def choose_practice_default
    session[:current_lesson_id] = params[:lesson_id]
    redirect_to("/practice")
  end
  
  def initialize_practice_lesson
    @pile = Pile.new
    
    @pile.user_id = params[:user_id]
    @pile.translate = params[:translate]
    
    lesson = Lesson.find(params[:lesson_id])
    @pile.vocab = lesson.vocabs.pluck(:id)
    
    @pile.save
    
    redirect_to("/practice/#{@pile.id}/", :notice => "New practice session started.")
  end
  
  def win
    @vocab_id = params[:vocab_id]
    @pile = Pile.find(params[:pile_id])

    ## Record win
    Pile.record_win_to_pile(@pile.id, @vocab_id)
    Vocab.record_win(@pile.translate, @vocab_id)
    PracticeLog.record_practice_to_log(@pile.id, @vocab_id, "win")

    ## Redirect to new card
    redirect_to("/practice/#{@pile.id}", :notice => "win recorded! :)")
  end
  
  
  def loss
    @vocab_id = params[:vocab_id]
    @pile = Pile.find(params[:pile_id])
    
    ## Record loss
    Pile.record_loss_to_pile(@pile.id, @vocab_id)
    Vocab.record_loss(@pile.translate, @vocab_id)
    PracticeLog.record_practice_to_log(@pile.id, @vocab_id, "loss")
    
    ## Redirect to new card
    redirect_to("/practice/#{@pile.id}", :alert => "loss recorded :(")
  end
  
  ## Choose a new card
  def new_card
    @pile = Pile.find(params[:pile_id])
    
    ## If no cards left, go to "completed" page
    if @pile.vocab.count==0
      render("complete.html.erb")
    
    ## If cards left, choose a new card
    ## Consider refactoring this piece of logic ##
    else 
      ## If only one word remaining, don't have multiples of it
      if @pile.vocab.uniq.count == 1 
        @pile.vocab = @pile.vocab.uniq
        @pile.save
      end
      
      ## Choose new card 
      if @pile.vocab_priority.count == 0
        new_vocab_id = @pile.vocab.sample
      elsif @pile.vocab_priority.count > 4.0 
        new_vocab_id = @pile.vocab_priority.sample
      elsif rand() > 0.5
        new_vocab_id = @pile.vocab_priority.sample
      else 
        new_vocab_id = @pile.vocab.sample
      end
      @vocab = Vocab.find(new_vocab_id)
      render("piles/practice_card")
    end
  end
  
  def practice_card_answer
    @pile = Pile.find(params[:pile_id])
    @vocab = Vocab.find(params[:vocab_id])

    render("piles/practice_answer")
  end
  
  def index
    @piles = Pile.all

    render("piles/index.html.erb")
  end

  def show
    @pile = Pile.find(params[:id])

    render("piles/show.html.erb")
  end
  
  def practice_log 
    @practice_log = PracticeLog.where(user_id: current_user.id)
    
    render("/piles/practice_log.html.erb")
  end

## SOME STUFF I DON'T THINK I WILL NEED
#  def new
#    @pile = Pile.new

#    render("piles/new.html.erb")
#  end

#  def create
#    @pile = Pile.new

#    @pile.user_id = params[:user_id]
#    @pile.vocab = params[:vocab]

#    save_status = @pile.save

#    if save_status == true
#      redirect_to("/piles/#{@pile.id}", :notice => "Pile created successfully.")
#    else
#      render("piles/new.html.erb")
#    end
 # end

#  def edit
#    @pile = Pile.find(params[:id])

#    render("piles/edit.html.erb")
#  end

#  def update
#    @pile = Pile.find(params[:id])

#    @pile.user_id = params[:user_id]
#    @pile.vocab = params[:vocab]
#    @pile.vocab_w = params[:vocab_w]
#    @pile.vocab_l = params[:vocab_l]

#    save_status = @pile.save

#    if save_status == true
#      redirect_to("/piles/#{@pile.id}", :notice => "Pile updated successfully.")
#    else
#      render("piles/edit.html.erb")
#    end
# end

  def destroy
    @pile = Pile.find(params[:id])

    @pile.destroy

    if URI(request.referer).path == "/piles/#{@pile.id}"
      redirect_to("/", :notice => "Pile deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Pile deleted.")
    end
  end
end
