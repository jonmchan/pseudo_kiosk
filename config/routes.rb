PseudoKiosk::Engine.routes.draw do
  namespace :pseudo_kiosk do
    get 'authentication/unlock'
    get 'authentication/process_submit'
  end
end
