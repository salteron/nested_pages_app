VALID_PAGE_PATH_REGEXP = /(\w+\/)*(?!edit)\w+/

NestedPagesApp::Application.routes.draw do

  root                     to: 'pages#index'
  match '/add',            to: 'pages#new',      via: 'get'

  # bug: niether constraints: {page_path: regexp} nor
  # constraints ... do ... end don't work
  # https://github.com/rails/rails/issues/7924
  match '*page_path/add',  to: 'pages#new',      via: 'get',
                              page_path: VALID_PAGE_PATH_REGEXP

  match '*page_path/edit', to: 'pages#edit',     via: 'get',
                              page_path: VALID_PAGE_PATH_REGEXP

  match '*page_path',      to: 'pages#show',     via: 'get',
                              page_path: VALID_PAGE_PATH_REGEXP

  resources :pages, only: [:create, :update]                              

end


