module PseudoKiosk
  module TestHelpers
    module Internal
      module Rails
        def pseudo_kiosk_reload!
          ActionController::Base.send(:include, PseudoKiosk::Controller)
        end
      end
    end
  end
end