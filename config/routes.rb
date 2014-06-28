Pop3EmailGrabber::Application.routes.draw do
  devise_for :users, path: "auth", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
  get '/' => "welcome#index"
  get 'dynamic_header' => "welcome#dynamic_header", format: "js"

  namespace :dashboard do
    get '/' => "mail_boxes#index"
    resources :mail_boxes, except: [:show] do
    end
  end
end
