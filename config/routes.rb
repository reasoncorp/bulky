Rails.application.routes.draw do
  namespace :bulky do
    put 'admin/retry/:id',  to: 'admin/updates#retry',         as: 'retry'
    get 'admin/:id',        to: 'admin/updates#show',          as: 'show'
    get 'admin',            to: 'admin/updates#index',         as: 'index'
    get ':model/edit',      to: 'updates#edit',                as: 'edit'
    put ':model',           to: 'updates#update',              as: 'update'
  end
end
