Pop3EmailGrabber::Application.routes.draw do
  devise_for :users, path: "auth", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
  get '/' => "welcome#index"
end
