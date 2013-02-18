Rails.application.routes.draw do
  namespace :bulky do
    get '/retry/:id',       to: 'admin/updates#retry',         as: 'retry'
    get ':model/edit',      to: 'updates#edit',    as: 'edit'
    put ':model',           to: 'updates#update',  as: 'update'
    get ':id',              to: 'admin/updates#show',          as: 'show'
    get '',                 to: 'admin/updates#index',         as: 'index'
  end
end
