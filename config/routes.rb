PseudoKiosk::Engine.routes.draw do
  namespace :pseudo_kiosk, path: '' do
    get 'authentication/unlock'
    get 'authentication/process_submit'
  end
end
