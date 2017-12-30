class LessonsController < ApplicationController
  def index
    @lessons = Lesson.all.order(name: :asc)
    render("lessons/index.html.erb")
  end

  def my_index
    @lessons = Lesson.where(owner_id: current_user.id).order(created_at: :desc)
    render("lessons/my_index.html.erb")
  end

  def show
    @lesson = Lesson.find(params[:id])
    @vocabs = Vocab.where(lesson_id: @lesson.id)
    
    session[:current_lesson_id] = @lesson.id
    
    render("lessons/show.html.erb")
  end

  def new
    @lesson = Lesson.new

    render("lessons/new.html.erb")
  end

  def create
    @lesson = Lesson.new

    @lesson.name = params[:name]
    @lesson.owner_id = params[:owner_id]

    save_status = @lesson.save
    
    session[:current_lesson_id] = @lesson.id

    if save_status == true
      redirect_to("/modules/#{@lesson.id}", :notice => "Lesson created successfully.")
    else
      render("lessons/new.html.erb")
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])

    render("lessons/edit.html.erb")
  end

  def update
    @lesson = Lesson.find(params[:id])

    @lesson.name = params[:name]
    @lesson.owner_id = params[:owner_id]

    save_status = @lesson.save

    if save_status == true
      redirect_to("/modules/#{@lesson.id}", :notice => "Lesson updated successfully.")
    else
      render("lessons/edit.html.erb")
    end
  end

  def destroy
    @lesson = Lesson.find(params[:id])

    @lesson.destroy
    
    session[:current_lesson_id] = nil

    if URI(request.referer).path == "/modules/#{@lesson.id}"
      redirect_to("/", :notice => "Module deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Lesson deleted.")
    end
  end
end
