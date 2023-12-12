Rails.application.routes.draw do
  root to: 'employees#welcome'
   get 'employees/search', to: 'employees#search'
   resources :employees
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
