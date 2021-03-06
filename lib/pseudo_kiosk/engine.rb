module PseudoKiosk
  class Engine < ::Rails::Engine
    #config.pseudo_kiosk = PseudoKiosk::Config
    # Do we need this for what we're doing?
    # isolate_namespace PseudoKiosk

    initializer 'extend Controller with PseudoKiosk' do
      if defined?(ActionController::Base)
        ActionController::Base.send(:include, PseudoKiosk::Controller)
      end
    end
  end
end
