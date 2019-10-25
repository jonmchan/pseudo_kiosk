class PseudoKiosk::AuthenticationController < ApplicationController
  def unlock
    render :layout => false
  end

  def process_submit
  end
end
