require "pseudo_kiosk/engine"

module PseudoKiosk
  autoload(:Config, 'pseudo_kiosk/config')
  require 'pseudo_kiosk/controller'
  module TestHelpers
    require 'pseudo_kiosk/test_helpers/internal'

    module Internal
      require 'pseudo_kiosk/test_helpers/internal/rails'
    end
  end
end
