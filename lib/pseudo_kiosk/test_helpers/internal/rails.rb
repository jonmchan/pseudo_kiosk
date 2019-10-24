module PseudoKiosk
  module TestHelpers
    module Internal
      module Rails
        def pseudo_kiosk_reload!
          PseudoKiosk::Config.init!
          PseudoKiosk::Config.reset!

          ActionController::Base.send(:include, PseudoKiosk::Controller)
        end

        def pseudo_kiosk_config_property_set(property, value)
          ::PseudoKiosk::Config.send(:"#{property}=", value)
        end

        # def pseudo_kiosk_config_external_property_set(provider, property, value)
        #   ::PseudoKiosk::Config.send(provider).send(:"#{property}=", value)
        # end
      end
    end
  end
end