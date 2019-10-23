module KioskLock
  module Controller
    # code borrowed from Sorcery (https://github.com/Sorcery/sorcery/blob/ae83ac3181aed9696bf78ceabcce96bf735fd7ea/lib/sorcery/controller.rb)
    def self.included(klass)
      klass.class_eval do
        include InstanceMethods
      #Config.update!
      #Config.configure!
    end

    module InstanceMethods
      # To be used in before_action in the application_controller.
      # If kiosk_locked, all endpoints that are not in the kiosk_whitelist 
      # will not allowed to be accessed
      def check_kiosk_lock
        #  this needs to go to the unlock screen
        if session[:kiosk_locked]
          # TODO: need to follow lock_kiosk logic
          redirect_to "http://endoftheinternet.com/"
        end
      end

      # Locks the system down
      #
      # Params:
      # url_whitelist - an array of url strings or regex searches 
      # of endpoints allowed to be visited during kiosk lock mode
      #
      # unauthorized_endpoint_redirect - url to redirect to if user navigates
      # to a url outside of the url_whitelist. 
      # If nil, the unlock screen will be shown when navigating to urls 
      # outside of the whitelist; upon successful authentication, the user 
      # will be redirected to current endpoint
      def lock_kiosk(url_whitelist, unauthorized_endpoint_redirect_url)
        session[:kiosk_locked] = true
        session[:kiosk_whitelist] = url_whitelist
        session[:kiosk_unauthorized_endpoint_redirect_url] = unauthorized_endpoint_redirect_url
      end


      # if successfully unlocked, the user is redirected to the unlock_redirect_url
      def unlock_kiosk(unlock_redirect_url)
        session[:kiosk_unlock_redirect_url] = unlock_redirect_url
      end



      # clear all kiosk lock session variables; this is an internal function
      # Most likely unlock_kiosk is what should be used, unless there is some usecase
      # where you want to instantly unlock the kiosk without going through authentication
      def clear_kiosk_lock
        session.delete(:kiosk_locked)
        session.delete(:kiosk_whitelist)
        session.delete(:kiosk_unauthorized_endpoint_redirect_url)
        session.delete(:kiosk_unlock_redirect_url)
      end
    end
