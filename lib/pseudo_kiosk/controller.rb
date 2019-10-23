module PseudoKiosk 
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
      # If pseudo_kiosk enabled, all endpoints that are not in the kiosk_whitelist 
      # will not allowed to be accessed
      def ensure_pseudo_kiosk
        #  this needs to go to the unlock screen
        if session[:pseudo_kiosk_enabled]
          # TODO: need to follow lock_kiosk logic
          redirect_to "http://endoftheinternet.com/"
        end
      end

      # Locks the session down for unprivileged usage
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
      def pseudo_kiosk_start(url_whitelist, unauthorized_endpoint_redirect_url)
        session[:pseudo_kiosk_enabled] = true
        session[:pseudo_kiosk_whitelist] = url_whitelist
        session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = unauthorized_endpoint_redirect_url
      end


      # redirects to pseudo_kiosk unlock screen. When successfully unlocked, the browser is 
      # redirected to the unlock_redirect_url
      def pseudo_kiosk_exit(unlock_redirect_url)
        session[:pseudo_kiosk_unlock_redirect_url] = unlock_redirect_url
 
        # clear the whitelist here, because we want to only allow 
        # the session to be given back to the privileged user and
        # for no further operations to be done in the whitelist area
        session.delete(:pseudo_kiosk_whitelist)

      end



      # clear all pseudo_kiosk session variables; this is an internal function
      # Most likely pseudo_kiosk_exit is what should be used, unless there is some usecase
      # where you want to instantly exit the pseudo_kiosk session without going through authentication
      def clear_pseudo_kiosk_session
        session.delete(:pseudo_kiosk_enabled)
        session.delete(:pseudo_kiosk_whitelist)
        session.delete(:pseudo_kiosk_unauthorized_endpoint_redirect_url)
        session.delete(:pseudo_kiosk_unlock_redirect_url)
      end
    end