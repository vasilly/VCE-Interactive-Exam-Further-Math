Rails.application.routes.draw do
  root to: 'articles#index'#changes start page to index, instead of standard home page.
  resources :articles
resources :articles do
  resources :comments
end

end


