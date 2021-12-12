Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/title', to: 'titles#create'
  get '/user_title/:sub',to: 'titles#user_title'
  get '/title', to: 'titles#send_to_client_all'
  get '/title/:id/:sub/:switch', to: 'titles#send_to_client'
  get '/title/:id', to: 'titles#send_to_client'
  get '/title_content0', to: 'titles#send_to_client0'
  get '/title_rank', to: 'titles#rank'
  post '/answer', to: 'titles#answer'
 
  resource :good_users
end
