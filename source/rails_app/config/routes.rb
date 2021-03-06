Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #devise_for :users, controllers: { registrations: 'users/registrations' }

  # === deviseのルーティング制限
  # userの更新・削除はprofile_controllerで行うので、registrationsでは新規作成と削除のみ許可
  devise_for :users, skip: [:registrations]
  devise_scope :user do
    get    'users/registrations'         => 'users/registrations#new',     as: :new_user_registration
    post   'users/registrations'         => 'users/registrations#create',  as: :user_registration
    delete 'users/registrations/destroy' => 'users/registrations#destroy', as: :destroy_user_registration
  end

  scope module: 'authed' do
    root 'dashboard#index'
    get  'dashboard',          to: 'dashboard#index'
    post 'api/select_project', to: 'api#select_project'

    get  'profile/index',         to: 'profile#index'
    get  'profile/edit',          to: 'profile#edit'
    post 'profile/edit',          to: 'profile#update'
    get  'profile/edit_image',    to: 'profile#edit_image'
    post 'profile/edit_image',    to: 'profile#update_image'
    get  'profile/edit_password', to: 'profile#edit_password'
    post 'profile/edit_password', to: 'profile#update_password'

    resources :projects
    resources :tickets do
      member do
        get :download_attachment_file
      end
    end

    namespace :admin do
      get 'top',        to: 'top#index'
      get 'create_pdf', to: 'top#create_pdf'
      get 'create_png', to: 'top#create_png'
      get 'node_call',  to: 'top#node_call'
      resources :notifications, except: [:edit, :update]
    end
  end

end
