Rails.application.routes.draw do
  # Routes for the Pile resource:
  
  # CREATE NEW PILE
  get "/practice", :controller => "piles", :action => "choose_practice"
  get "/practice/default/:lesson_id", :controller => "piles", :action => "choose_practice_default"
  post "/initialize_practice_lesson", :controller => "piles", :action => "initialize_practice_lesson"
  
  # GO THROUGH PILE (EDIT)
  get "/practice/:pile_id", :controller => "piles", :action => "new_card"
  get "/practice/:pile_id/:vocab_id/answer", :controller => "piles", :action => "practice_card_answer"
  get "/practice/:pile_id/:vocab_id/win", :controller => "piles", :action => "win"
  get "/practice/:pile_id/:vocab_id/loss", :controller => "piles", :action => "loss"
  
  ## Practice log
  get "/practice_log", :controller => "piles", :action => "practice_log"
  
  # CREATE
 # get "/piles/new", :controller => "piles", :action => "new"
#  post "/create_pile", :controller => "piles", :action => "create"

  # READ
  get "/piles", :controller => "piles", :action => "index"
  get "/piles/:id", :controller => "piles", :action => "show"

#  UPDATE
#  get "/piles/:id/edit", :controller => "piles", :action => "edit"
#  post "/update_pile/:id", :controller => "piles", :action => "update"

  # DELETE
  get "/delete_pile/:id", :controller => "piles", :action => "destroy"
  #------------------------------
 
  devise_for :users

  root 'lessons#my_index'

  # Routes for the Vocab resource:
  # CREATE
  get "/vocabs/new", :controller => "vocabs", :action => "new"
  post "/create_vocab", :controller => "vocabs", :action => "create"

  # READ
  get "/vocabs/index/all", :controller => "vocabs", :action => "index_all"
  get "/vocabs/index", :controller => "vocabs", :action => "index"
  get "/vocabs/:id", :controller => "vocabs", :action => "show"

  # UPDATE
  get "/vocabs/:id/edit", :controller => "vocabs", :action => "edit"
  post "/update_vocab/:id", :controller => "vocabs", :action => "update"

  # DELETE
  get "/delete_vocab/:id", :controller => "vocabs", :action => "destroy"
  #------------------------------

  # Routes for the Lesson resource:
  # CREATE
  get "/modules/new", :controller => "lessons", :action => "new"
  post "/create_lesson", :controller => "lessons", :action => "create"

  # READ
  get "/modules", :controller => "lessons", :action => "my_index"
  get "/all_lessons", :controller => "lessons", :action => "index"
  get "/modules/:id", :controller => "lessons", :action => "show"

  # UPDATE
  get "/modules/:id/edit", :controller => "lessons", :action => "edit"
  post "/update_lesson/:id", :controller => "lessons", :action => "update"

  # DELETE
  get "/delete_lesson/:id", :controller => "lessons", :action => "destroy"
  #------------------------------

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
