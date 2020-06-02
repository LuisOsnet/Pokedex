Rails.application.routes.draw do
  get 'pokemons/index'
  root 'pokemons#index'
end
