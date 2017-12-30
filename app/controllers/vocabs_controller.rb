class VocabsController < ApplicationController
  def index
    @vocabs = Vocab.where(owner_id: current_user.id).order(:lesson_id, :created_at)
    @index_all=false

    render("vocabs/index.html.erb")
  end
  
  def index_all
    @vocabs = Vocab.all.order(:english)
    @index_all=true
    
    render("vocabs/index.html.erb")
  end

  def show
    @vocab = Vocab.find(params[:id])

    render("vocabs/show.html.erb")
  end

  def new
    @vocab = Vocab.new

    render("vocabs/new.html.erb")
  end

  def create
    @vocab = Vocab.new

    @vocab.lesson_id = params[:lesson_id]
    @vocab.english = params[:english]
    @vocab.chinese = params[:chinese]
    @vocab.notes = params[:notes]
    @vocab.e2c_w = 0
    @vocab.e2c_l = 0
    @vocab.c2e_w = 0
    @vocab.c2e_l = 0
    @vocab.owner_id = params[:owner_id]

    save_status = @vocab.save

    if save_status == true
      redirect_to("/modules/#{session[:current_lesson_id]}", :notice => "Vocab created successfully.")
    else
      render("vocabs/new.html.erb")
    end
  end

  def edit
    @vocab = Vocab.find(params[:id])

    render("vocabs/edit.html.erb")
  end

  def update
    @vocab = Vocab.find(params[:id])

    @vocab.lesson_id = params[:lesson_id]
    @vocab.english = params[:english]
    @vocab.chinese = params[:chinese]
    @vocab.notes = params[:notes]
    @vocab.e2c_w = params[:e2c_w]
    @vocab.e2c_l = params[:e2c_l]
    @vocab.c2e_w = params[:c2e_w]
    @vocab.c2e_l = params[:c2e_l]
    @vocab.owner_id = params[:owner_id]

    save_status = @vocab.save

    if save_status == true
      redirect_to("/vocabs/#{@vocab.id}", :notice => "Vocab updated successfully.")
    else
      render("vocabs/edit.html.erb")
    end
  end

  def destroy
    @vocab = Vocab.find(params[:id])

    @vocab.destroy

    if URI(request.referer).path == "/vocabs/#{@vocab.id}"
      redirect_to("/", :notice => "Vocab deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Vocab deleted.")
    end
  end
end
