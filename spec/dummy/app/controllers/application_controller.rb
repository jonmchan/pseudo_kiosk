class ApplicationController < ActionController::Base
  before_action :secure_pseudo_kiosk
end
