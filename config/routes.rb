Rails.application.routes.draw do
  resource :alive, only: :show

  mount API => "/"
end
