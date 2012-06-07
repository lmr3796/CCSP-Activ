Activ::Application.routes.draw do

  get "/manage/new" => "manage#manage_event"
  get "/manage/new/oauth2callback" => "manage#manage_event"
  get "/manage/manage" => "manage#manage"
 

  get "/new_event/new" => "new_event#new"
  get "/new_event/new/oauth2callback" => "new_event#new"
  post "/new_event/new" => "new_event#done"

  match  "/calendar/oauth2callback"

  get    "/calendar"      => "calendar#create_cal"

  delete "/calendar/acl"  => "calendar#delete_acl"
  post   "/calendar/acl"  => "calendar#create_acl"

  #get    "/calendar/get_list"
  #get    "/calendar/create_list"

  #get    "drive" => "drive#oauth2callback"
  #get    "drive/oauth2authorize" => "drive#oauth2authorize"
  #get    "drive/oauth2callback"  => "drive#oauth2callback"

  get    "light" => "light#show", :as => :light
  post   "light" => "light#create"
  delete "light" => "light#delete"

  post   "light/music" => "light#music_url"

  post   "light/repeat" => "light#create_repeat"
  delete "light/repeat" => "light#delete_repeat"

  get "/" => "home#index", :as => :home
  post "/" => "home#index"

  post "/login" => "home#login"
  get "/login" => "home#login"
  post "home/create_event" => 'home#create_event_done'
  match ':controller(/:action(/:id2))(.:format)'
  get "/event" => "event#index" , :as => :event
  post "/event" => "event#index"
  post "/event/get_ajax" => "event#get_ajax"
  #match "events/:id" => "event#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
end
