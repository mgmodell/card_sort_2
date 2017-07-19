# frozen_string_literal: true

Rails.application.routes.draw do
  resources :datasets, only: [:show, :edit, :update, :destroy ]
  resources :sources, only: [:show, :edit, :update, :destroy ]

  get 'sources/add_refs/:id' => 'sources#add_refs', as: 'add_refs_to_source'
  get 'sources/process/:id' => 'sources#data_proc', as: 'process_source'
  get 'datasets/process/:id' => 'datasets#data_proc', as: 'process_dataset'

  get 'home/load/:key' => 'home#load', as: 'new_dataset'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
