Rails.application.routes.draw do
  resources :score_registers
  get "top10/:id", to: "score_registers#getTop"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
