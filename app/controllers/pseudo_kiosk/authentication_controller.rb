class PseudoKiosk::AuthenticationController < ApplicationController
  def unlock
    unless session[:pseudo_kiosk_enabled]
      redirect_back(fallback_location: root_path) 
      return
    end
    render :layout => false
  end

  def process_submit
    unless session[:pseudo_kiosk_enabled]
      redirect_back(fallback_location: root_path) 
      return
    end
    if PseudoKiosk::Config.unlock_mechanism.nil?
      raise "PseudoKiosk::Config.unlock_mechanism is missing!"
    elsif PseudoKiosk::Config.unlock_mechanism.is_a? String
      PseudoKiosk::Config.unlock_mechanism == params[:passcode] ? unlock_success : unlock_fail
    elsif PseudoKiosk::Config.unlock_mechanism.is_a? Proc 
      PseudoKiosk::Config.unlock_mechanism.call(self, params) ? unlock_success : unlock_fail
    else 
      raise "No clue how to use an PseudoKiosk::Config.unlock_mechanism that is a #{PseudoKiosk::Config.unlock_mechanism.class}!"
    end
  end

  private
  def unlock_success
    redirect_url = session[:pseudo_kiosk_unlock_redirect_url]
    clear_pseudo_kiosk_session
    redirect_to redirect_url
  end

  def unlock_fail
    redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path(failed: "true"))
  end
end
