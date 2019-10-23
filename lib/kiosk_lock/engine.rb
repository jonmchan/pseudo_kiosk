module KioskLock
  class Engine < ::Rails::Engine
    # Do we need this for what we're doing?
    # isolate_namespace KioskLock

    initializer 'extend Controller with KioskLock' do
      if defined?(ActionController::Base)
        ActionController::Base.send(:include, KioskLock::Controller)
      end
    end
  end
end
