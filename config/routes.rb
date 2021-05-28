Rails.application.routes.draw do

  root to: 'visitors#index'

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :visitors, only: [:index] do
    collection do
      get :manual
    end
  end

  # resources :rts do
  #   collection do
  #     post :import_insales
  #     get :unlinking_to_xls
  #   end
  # end

  resources :products do
    collection do
      get :create_csv
      get :edit_multiple
      put :update_multiple
      post :delete_selected
      post :import
      get :import_insales_xml
      get :update_price_quantity_all_providers
      get :csv_param
      get :syncronaize
      get :linking
      get :export_api
    end
  end

  mount ActionCable.server => '/cable'
end
