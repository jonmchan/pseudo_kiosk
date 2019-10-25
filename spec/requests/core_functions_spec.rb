require 'rails_helper'


describe 'PseudoKiosk Core Functions Integration Tests', type: :request do
  before(:all) do
    pseudo_kiosk_reload!
  end

  describe 'ActionController::Base#secure_pseudo_kiosk' do
    describe 'whitelist tests' do
      context 'single string' do
        let(:endpoints) {
          { 
            test_work_flow_pseudo_kiosk_start_action_path => false,
            test_work_flow_pseudo_kiosk_exit_action_path => false,
            test_work_flow_clear_pseudo_kiosk_session_action => false,
            test_work_flow_start_step1_privilege_path => true,
            test_work_flow_complete_step1_privilege_path => false,
            test_work_flow_start_step2_unprivilege_path => false,
            test_work_flow_complete_step2_privilege_path => false,
            test_work_flow_start_step3_privilege_path => false,
            test_work_flow_complete_step3_privilege_path => false,
           }
        }
        before do
          get 
          session[:pseudo_kiosk_enabled] = true
          session[:pseudo_kiosk_whitelist] = test_work_flow_start_step1_privilege_path
          session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = nil
        end

        it 'allows the single whitelisted endpoint to be reached, but no other' do
          endpoints.each do | endpoint, is_allowed_endpoint |
            if is_allowed_endpoint
              expect(get endpoint).to have_http_status(200)
            else
              expect(get endpoint).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
            end
          end
        
        end
      end
      context 'regex expression' do

      end

      context 'multiple items' do

      end
    end    
  end
end