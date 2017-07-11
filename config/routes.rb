# frozen_string_literal: true

Rails.application.routes.draw do
  resources :datasets, only: [:show, :edit, :update, :destroy ]

  get 'datasets/add_source/:id' => 'datasets#add_source', as: 'add_source_to_dataset'
  get 'datasets/process/:id' => 'datasets#process', as: 'process_dataset'

  get 'home/load/:key' => 'home#load', as: 'new_dataset'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
