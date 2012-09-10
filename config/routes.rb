Rails.application.routes.draw do
  namespace :bulky do
    get ':model/edit', to: 'updates#edit',   as: 'edit'
    put ':model',      to: 'updates#update', as: 'update'
  end
end
