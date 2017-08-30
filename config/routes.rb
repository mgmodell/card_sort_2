# frozen_string_literal: true

Rails.application.routes.draw do
  resources :datasets, only: %i[show edit update destroy]
  resources :sources, only: %i[show edit update destroy]

  post 'sources/add_refs/:id' => 'sources#add_refs', as: 'add_refs_to_source'
  get 'sources/process/:id' => 'sources#data_proc', as: 'process_source'
  get 'sources/data/:id/:type' => 'sources#get_data', as: 'source_data',
      constraints: ->(req) { req.format == :json }

  get 'datasets/process/:id' => 'datasets#data_proc', as: 'process_dataset'
  get 'datasets/calc_stats/:id' => 'datasets#calc_stats', as: 'calc_dataset_stats'
  get 'datasets/data/:id/:type' => 'datasets#get_data', as: 'dataset_data',
      constraints: ->(req) { req.format == :json }

  get 'home/pull/:key' => 'home#pull', as: 'new_dataset'
  get 'home/update_synonyms' => 'home#update_synonyms', as: 'update_synonyms'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
