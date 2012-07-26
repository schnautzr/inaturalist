Inaturalist::Application.routes.draw do
  id_param_pattern = %r(\d+([\w\-\%]*))
  simplified_login_regex = /\w[^\.,\/]+/  
  resources :observation_field_values
  resources :observation_fields
  match '/' => 'welcome#index'
  match '/home' => 'users#dashboard', :as => :home
  match '/home.:format' => 'users#dashboard', :as => :formatted_home
  
  devise_for :users
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end
  match '/register' => 'users#create', :as => :register, :via => :post
  match '/signup'   => 'users#new', :as => :signup
  
  
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  match '/forgot_password' => 'passwords#new', :as => :forgot_password
  match '/change_password/:reset_code' => 'passwords#reset', :as => :change_password
  match '/toggle_mobile' => 'welcome#toggle_mobile', :as => :toggle_mobile
  match '/help' => 'help#index', :as => :help
  match '/auth/failure' => 'provider_authorizations#failure', :as => :omniauth_failure
  match '/auth/:provider' => 'provider_authorizations#blank'
  match '/auth/:provider/callback' => 'provider_authorizations#create', :as => :omniauth_callback
  match '/auth/:provider/disconnect' => 'provider_authorizations#destroy', :as => :omniauth_disconnect, :method => 'delete'
  match '/users/edit_after_auth' => 'users#edit_after_auth', :as => :edit_after_auth
  match '/facebook/photo_fields' => 'facebook#albums'
  match "/eol/photo_fields" => "eol#photo_fields"
  match '/flickr/invite' => 'photos#invite', :provider => 'flickr'
  match '/facebook/invite' => 'photos#invite', :provider => 'facebook'
  resources :announcements
  match '/users/dashboard' => 'users#dashboard', :as => :dashboard
  match '/users/curation' => 'users#curation', :as => :curate_users
  match '/users/updates_count' => 'users#updates_count', :as => :updates_count
  match '/users/new_updates' => 'users#new_updates', :as => :new_updates
  
  resources :users
  # resource :session
  # resources :passwords
  resources :people, :controller => :users
  match '/users/:id/suspend' => 'users#suspend', :as => :suspend_user, :constraints => { :id => /\d+/ }
  match '/users/:id/unsuspend' => 'users#unsuspend', :as => :unsuspend_user, :constraints => { :id => /\d+/ }
  match 'users/:id/add_role' => 'users#add_role', :as => :add_role, :constraints => { :id => /\d+/ }, :method => :post
  match 'users/:id/remove_role' => 'users#remove_role', :as => :remove_role, :constraints => { :id => /\d+/ }, :method => :delete
  match 'photos/local_photo_fields' => 'photos#local_photo_fields', :as => :local_photo_fields
  resources :photos, :only => [:show, :update]
  resources :observation_photos, :only => :create
  match 'flickr/photos.:format' => 'flickr#photos', :via => :get
  resources :observations, :constraints => { :id => id_param_pattern } do
    resources :flags
  end

  match 'observations/identotron' => 'observations#identotron', :as => :identotron
  match 'observations/update' => 'observations#update', :as => :update_observations
  match 'observations/new/batch_csv' => 'observations#new_batch_csv', :as => :new_observation_batch_csv
  match 'observations/new/batch' => 'observations#new_batch', :as => :new_observation_batch
  match 'observations/edit/batch' => 'observations#edit_batch', :as => :edit_observation_batch
  match 'observations/delete_batch' => 'observations#delete_batch', :as => :delete_observation_batch, :via => :delete
  match 'observations/import' => 'observations#import', :as => :import_observations
  match 'observations/import_photos' => 'observations#import_photos', :as => :import_photos
  match 'observations/id_please' => 'observations#id_please', :as => :id_please, :via => :get
  match 'observations/selector' => 'observations#selector', :as => :observation_selector, :via => :get
  match '/observations/curation' => 'observations#curation', :as => :curate_observations
  match '/observations/widget' => 'observations#widget', :as => :observations_widget
  match 'observations/add_from_list' => 'observations#add_from_list', :as => :add_observations_from_list
  match 'observations/new_from_list' => 'observations#new_from_list', :as => :new_observations_from_list
  match 'observations/nearby' => 'observations#nearby', :as => :nearby_observations
  match 'observations/add_nearby' => 'observations#add_nearby', :as => :add_nearby_observations
  match 'observations/:id/edit_photos' => 'observations#edit_photos', :as => :edit_observation_photos
  match 'observations/:id/update_photos' => 'observations#update_photos', :as => :update_observation_photos
  match 'observations/:login' => 'observations#by_login', :as => :observations_by_login, :constraints => { :login => /\w[^\.,\/]+/ }
  match 'observations/:login.:format' => 'observations#by_login', :as => :observations_by_login_feed, :constraints => { :login => /\w[^\.,\/]+/ }, :via => :get
  match 'observations/tile_points/:zoom/:x/:y.:format' => 'observations#tile_points', :as => :observation_tile_points, :constraints => { :zoom => /\d+/, :y => /\d+/, :x => /\d+/ }, :via => :get
  match 'observations/project/:id.:format' => 'observations#project', :as => :project_observations
  match 'observations/project/:id.all.:format' => 'observations#project_all', :as => :all_project_observations
  match 'observations/of/:id.:format' => 'observations#of', :as => :observations_of
  match 'observations/:id/quality/:metric' => 'quality_metrics#vote', :as => :observation_quality, :via => [:post, :delete]
  match 'projects/:id/join' => 'projects#join', :as => :join_project
  match 'projects/:id/leave' => 'projects#leave', :as => :leave_project
  match 'projects/:id/add' => 'projects#add', :as => :add_project_observation, :via => :post
  match 'projects/:id/remove' => 'projects#remove', :as => :remove_project_observation, :via => [:post, :delete]
  match 'projects/:id/add_batch' => 'projects#add_batch', :as => :add_project_observation_batch, :via => :post
  match 'projects/:id/remove_batch' => 'projects#remove_batch', :as => :remove_project_observation_batch, :via => [:post, :delete]
  match 'projects/search' => 'projects#search', :as => :project_search
  match 'projects/search.:format' => 'projects#search', :as => :formatted_project_search
  match 'project/:id/terms' => 'projects#terms', :as => :project_terms
  match 'projects/user/:login' => 'projects#by_login', :as => :projects_by_login, :constraints => { :login => /\w[^\.,\/]+/ }
  match 'projects/:id/members' => 'projects#members', :as => :project_members
  match 'projects/:id/contributors' => 'projects#contributors', :as => :project_contributors
  match 'projects/:id/contributors.:format' => 'projects#contributors', :as => :formatted_project_contributors
  match 'projects/:id/observed_taxa_count' => 'projects#observed_taxa_count', :as => :project_observed_taxa_count
  match 'projects/:id/observed_taxa_count.:format' => 'projects#observed_taxa_count', :as => :formatted_project_observed_taxa_count
  match 'projects/:id/species_count.:format' => 'projects#observed_taxa_count', :as => :formatted_project_species_count
  match 'projects/:id/contributors/:project_user_id' => 'projects#show_contributor', :as => :project_show_contributor
  match 'projects/:id/make_curator/:project_user_id' => 'projects#make_curator', :as => :make_curator
  match 'projects/:id/remove_curator/:project_user_id' => 'projects#remove_curator', :as => :remove_curator
  match 'projects/:id/remove_project_user/:project_user_id' => 'projects#remove_project_user', :as => :remove_project_user
  match 'projects/:id/stats' => 'projects#stats', :as => :project_stats
  match 'projects/:id/stats.:format' => 'projects#stats', :as => :formatted_project_stats
  match 'projects/browse' => 'projects#browse', :as => :browse_projects
  resources :projects
  resources :project_assets, :except => [:index, :show]
  resources :custom_projects, :except => [:index, :show]
  match 'people/:login' => 'users#show', :as => :person_by_login, :constraints => { :login => /\w[^\.,\/]+/ }
  match 'people/:login/followers' => 'users#relationships', :as => :followers_by_login, :constraints => { :login => /\w[^\.,\/]+/ }, :followers => 'followers'
  match 'people/:login/following' => 'users#relationships', :as => :following_by_login, :constraints => { :login => /\w[^\.,\/]+/ }, :following => 'following'
  resources :lists, :constraints => { :id => id_param_pattern }
  match 'lists/:id/taxa' => 'lists#taxa', :as => :list_taxa, :via => :get
  match 'lists/:id/taxa.:format' => 'lists#taxa', :as => :formatted_list_taxa, :via => :get
  match 'lists/:id.:view_type.:format' => 'lists#show',
    :as => 'list_show_formatted_view',
    :requirements => { :id => id_param_pattern }
  resources :life_lists
  resources :check_lists
  resources :project_lists
  resources :listed_taxa
  match 'lists/:login' => 'lists#by_login', :as => :lists_by_login, :constraints => { :login => /\w[^\.,\/]+/ }
  match 'lists/:id/compare' => 'lists#compare', :as => :compare_lists, :constraints => { :id => /\d+([\w\-\%]*)/ }
  match 'lists/:id/remove_taxon/:taxon_id' => 'lists#remove_taxon', :as => :list_remove_taxon, :constraints => { :id => /\d+([\w\-\%]*)/ }, :via => :delete
  match 'lists/:id/add_taxon_batch' => 'lists#add_taxon_batch', :as => :list_add_taxon_batch, :constraints => { :id => /\d+([\w\-\%]*)/ }, :via => :post
  match 'check_lists/:id/add_taxon_batch' => 'check_lists#add_taxon_batch', :as => :check_list_add_taxon_batch, :constraints => { :id => /\d+([\w\-\%]*)/ }, :via => :post
  match 'lists/:id/reload_from_observations' => 'lists#reload_from_observations', :as => :list_reload_from_observations, :constraints => { :id => /\d+([\w\-\%]*)/ }
  match 'lists/:id/refresh' => 'lists#refresh', :as => :list_refresh, :constraints => { :id => /\d+([\w\-\%]*)/ }
  match 'lists/:id/generate_csv' => 'lists#generate_csv', :as => :list_generate_csv, :constraints => { :id => /\d+([\w\-\%]*)/ }
  resources :comments
  resources :project_invitations, :except => [:index, :show]
  match 'project_invitation/:id/accept' => 'project_invitations#accept', :as => :accept_project_invitation, :via => :post
  match 'taxa/names' => 'taxon_names#index'
  match 'taxa/names.:format' => 'taxon_names#index'
  resources :taxa, :constraints => { :id => id_param_pattern } do
    resources :taxon_names
    resources :flags
    get 'description' => 'taxa#describe', :on => :member, :as => :describe
  end
  resources :taxon_names
  # match 'taxa/:id/description' => 'taxa#describe', :as => :describe_taxon
  match 'taxa/:id/graft' => 'taxa#graft', :as => :graft_taxon
  match 'taxa/:id/children' => 'taxa#children', :as => :taxon_children
  match 'taxa/:id/children.:format' => 'taxa#children', :as => :formatted_taxon_children
  match 'taxa/:id/photos' => 'taxa#photos', :as => :taxon_photos
  match 'taxa/:id/edit_photos' => 'taxa#edit_photos', :as => :edit_taxon_photos
  match 'taxa/:id/update_photos' => 'taxa#update_photos', :as => :update_taxon_photos
  match 'taxa/:id/update_colors' => 'taxa#update_colors', :as => :update_taxon_colors
  match 'taxa/:id/add_places' => 'taxa#add_places', :as => :add_taxon_places
  match 'taxa/flickr_tagger' => 'taxa#flickr_tagger', :as => :flickr_tagger
  match 'taxa/flickr_tagger.:format' => 'taxa#flickr_tagger', :as => :formatted_flickr_tagger
  match 'taxa/tag_flickr_photos_from_observations', :via => :post
  match 'taxa/search' => 'taxa#search', :as => :search_taxa
  match 'taxa/search.:format' => 'taxa#search', :as => :formatted_search_taxa
  match 'taxa/:action.:format' => 'taxa#index', :as => :formatted_taxa_action
  match 'taxa/:id/merge' => 'taxa#merge', :as => :merge_taxon
  match 'taxa/:id/merge.:format' => 'taxa#merge', :as => :formatted_merge_taxon
  match 'taxa/:id/observation_photos' => 'taxa#observation_photos', :as => :taxon_observation_photos
  match 'taxa/:id/map' => 'taxa#map', :as => :taxon_map
  match 'taxa/:id/range.:format' => 'taxa#range', :as => :taxon_range_geom
  match 'taxa/auto_complete_name' => 'taxa#auto_complete_name'
  match 'taxa/occur_in' => 'taxa#occur_in'
  match '/taxa/curation' => 'taxa#curation', :as => :curate_taxa
  match "taxa/*q" => 'taxa#try_show'
  
  resources :sources, :only => [:index, :show]
  match 'journal' => 'posts#browse', :as => :journals
  match 'journal/:login' => 'posts#index', :as => :journal_by_login, :constraints => { :login => simplified_login_regex }
  match 'journal/:login/archives/' => 'posts#archives', :as => :journal_archives, :constraints => { :login => simplified_login_regex }
  match 'journal/:login/archives/:year/:month' => 'posts#archives', :as => :journal_archives_by_month, :constraints => { :month => /\d{1,2}/, :year => /\d{1,4}/, :login => simplified_login_regex }
  resources :posts
  resources :posts,
    :as => 'journal_posts',
    :path => "/journal/:login",
    :constraints => { :login => simplified_login_regex }
  
  resources :identifications
  match 'identifications/:login' => 'identifications#by_login', :as => :identifications_by_login, :constraints => { :login => /\w[^\.,\/]+/ }, :via => :get
  match 'emailer/invite' => 'emailer#invite', :as => :emailer_invite
  match 'emailer/invite/send' => 'emailer#invite_send', :as => :emailer_invite_send, :via => :post
  resources :taxon_links, :except => [:show, :index]
  resources :places
  match '/places/find_external' => 'places#find_external', :as => :find_external
  match '/places/search' => 'places#search', :as => :place_search, :via => :get
  match '/places/:id/children' => 'places#children', :as => :place_children, :via => :get
  match 'places/:id/taxa.:format' => 'places#taxa', :as => :place_taxa, :via => :get
  match 'places/geometry/:id.:format' => 'places#geometry', :as => :place_geometry, :via => :get
  match 'places/guide/:id' => 'places#guide', :as => :place_guide, :via => :get
  match 'places/cached_guide/:id' => 'places#cached_guide', :as => :cached_place_guide, :via => :get
  match 'places/autocomplete' => 'places#autocomplete', :as => :autocomplete
  match 'places/autocomplete.:format' => 'places#autocomplete', :as => :formatted_autocomplete
  match '/guide' => 'places#guide', :as => :guide
  resources :flags
  match '/admin' => 'admin#index', :as => :admin
  resources :taxon_ranges, :except => [:index, :show]
  match '/calendar/:login' => 'calendars#index', :as => :calendar
  match '/calendar/:login/compare' => 'calendars#compare', :as => :calendar_compare
  match '/calendar/:login/:year/:month/:day' => 'calendars#show', :as => :calendar_date
  
  resources :subscriptions, :only => [:index, :edit, :create, :update, :destroy]
  match 'subscriptions/:resource_type/:resource_id' => "subscriptions#destroy", :as => :delete_subscription, :via => :delete
  match 'subscriptions/:resource_type/:resource_id/edit' => "subscriptions#edit", :as => :edit_subscription_by_resource
  
  match '/:controller(/:action(/:id))'
end
