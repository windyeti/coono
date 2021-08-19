Rails.application.routes.draw do

  root to: 'visitors#index'

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :visitors, only: [:index] do
    collection do
      get :manual
      get :mail_test
    end
  end

  resources :lit_koms do
    collection do
      get :parsing
    end
  end

  resources :kovchegs do
    collection do
      get :parsing
    end
  end

  resources :nkamins do
    collection do
      get :parsing
    end
  end

  resources :tmfs do
    collection do
      get :parsing
    end
  end

  resources :shulepovs do
    collection do
      get :parsing
    end
  end

  resources :realflames do
    collection do
      get :parsing
    end
  end

  resources :dims do
    collection do
      get :parsing
    end
  end

  resources :sawos do
    collection do
      get :parsing
    end
  end

  resources :saunarus do
    collection do
      get :parsing
    end
  end

  resources :teplodars do
    collection do
      get :parsing
    end
  end

  resources :contacts do
    collection do
      get :parsing
    end
  end

  resources :teplomarkets do
    collection do
      get :parsing
    end
  end

  resources :dantexgroups do
    collection do
      get :parsing
    end
  end

  resources :wellfits do
    collection do
      get :parsing
    end
  end

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
      get :export_csv
      get :csv_not_sku
    end
  end

  # mount ActionCable.server => '/cable'
end
