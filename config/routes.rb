BPSF::Application.routes.draw do
  root to: 'pages#home'

  resources :grants,       except: :index
  resources :draft_grants, except: [:show, :index]
  resources :payments,     except: [:index, :show, :edit, :update, :new]

  devise_for :users

  resources :drafts, controller: 'draft_grants', except: [:show, :index]
  scope '/drafts' do
    get ':id/edit_general/',   to: 'draft_grants#edit_general_info', as: :draft_edit_general
    get ':id/edit_logistics/', to: 'draft_grants#edit_logistics',    as: :draft_edit_logistics
    get ':id/edit_budget/',    to: 'draft_grants#edit_budget',       as: :draft_edit_budget
    get ':id/edit_methods/',   to: 'draft_grants#edit_methods',      as: :draft_edit_methods
  end

  namespace :admin do
    get '', to: 'dashboard#index', as: :dashboard
    post 'toggle_complete', to: 'dashboard#toggle_complete', as: :toggle_complete
  end

  namespace :recipient do
    get '', to: 'dashboard#index', as: :dashboard
  end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
