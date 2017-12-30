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
    
    @vocab_id = @pile.vocab.sample
    
    redirect_to("/practice/#{@pile.id}/#{@vocab_id}", :notice => "New practice session started.")
  end
  
  def win
    @pile = Pile.find(params[:pile_id])
    @vocab = Vocab.find(params[:vocab_id])
   
    @pile_vocab_priority = @pile.vocab_priority
    @pile_vocab = @pile.vocab
   
    ## Record win
    pile_vocab_w = @pile.vocab_w << @vocab.id
    @pile.vocab_w = pile_vocab_w

    ## If in priority, remove from priority
    if @pile_vocab_priority.include?(@vocab.id) == true
      @pile_vocab_priority.delete_at(@pile_vocab_priority.index(@vocab.id))
      @pile.vocab_priority = @pile_vocab_priority
    
    else ## Else remove from main list
      @pile_vocab.delete_at(@pile_vocab.index(@vocab.id))
      @pile.vocab = @pile_vocab
    end

    @pile.save   

    ## Redirect to new card
    
    if @pile_vocab.count==0
      redirect_to("/practice/#{@pile.id}/complete")
    else
      n = @pile_vocab_priority.count
      if n > 4.0 
        @new_vocab_id = @pile.vocab_priority.sample
      elsif n == 0
        @new_vocab_id = @pile.vocab.sample
      elsif rand() > 0.5
        @new_vocab_id = @pile.vocab_priority.sample
      else 
        @new_vocab_id = @pile.vocab.sample
      end
      redirect_to("/practice/#{@pile.id}/#{@new_vocab_id}", :notice => "win recorded")
    end
  
  end
  
  
  def loss
    @pile = Pile.find(params[:pile_id])
    @vocab = Vocab.find(params[:vocab_id])
   
    @pile_vocab_priority = @pile.vocab_priority
    @pile_vocab = @pile.vocab
   
    ## Record loss
    pile_vocab_l = @pile.vocab_l << @vocab.id
    @pile.vocab_l = pile_vocab_l
    
    ## Add card to priority list
    @pile.vocab_priority = @pile_vocab_priority.push(@vocab.id) 
    
    ## Add card to main list
    @pile.vocab = @pile_vocab.push(@vocab.id) 
    
    @pile.save

    ## Redirect to new card
    n = @pile_vocab_priority.count
    if n > 5.0 
      @new_vocab_id = @pile.vocab_priority.sample
    elsif n == 0
      @new_vocab_id = @pile.vocab.sample
    elsif rand() > 0.5
      @new_vocab_id = @pile.vocab_priority.sample
    else 
      @new_vocab_id = @pile.vocab.sample
    end

    redirect_to("/practice/#{@pile.id}/#{@new_vocab_id}", :notice => "loss recorded :(")
  end
  
  def completecs
    @pile = Pile.find(params[:pile_id])
    render("complete.html.erb")
  end
  
  def practice_card
    @pile = Pile.find(params[:pile_id])
    @vocab = Vocab.find(params[:vocab_id])
    
    render("/piles/practice_card")
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

  def new
    @pile = Pile.new

    render("piles/new.html.erb")
  end

  def create
    @pile = Pile.new

    @pile.user_id = params[:user_id]
    @pile.vocab = params[:vocab]

    save_status = @pile.save

    if save_status == true
      redirect_to("/piles/#{@pile.id}", :notice => "Pile created successfully.")
    else
      render("piles/new.html.erb")
    end
  end

  def edit
    @pile = Pile.find(params[:id])

    render("piles/edit.html.erb")
  end

  def update
    @pile = Pile.find(params[:id])

    @pile.user_id = params[:user_id]
    @pile.vocab = params[:vocab]
    @pile.vocab_w = params[:vocab_w]
    @pile.vocab_l = params[:vocab_l]

    save_status = @pile.save

    if save_status == true
      redirect_to("/piles/#{@pile.id}", :notice => "Pile updated successfully.")
    else
      render("piles/edit.html.erb")
    end
  end

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
