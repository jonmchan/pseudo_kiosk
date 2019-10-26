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
            test_work_flow_start_step1_privilege_path => true,
            test_work_flow_complete_step1_privilege_path(success: 'true') => false,
            test_work_flow_start_step2_unprivilege_path => false,
            test_work_flow_complete_step2_unprivilege_path(success: 'true') => false,
            test_work_flow_start_step3_privilege_path => false,
            test_work_flow_complete_step3_privilege_path(success: 'true') => false,
          }
        }
        before do
          get test_work_flow_pseudo_kiosk_start_action_path, params: { url_whitelist: test_work_flow_start_step1_privilege_path }
        end

        it 'allows the single whitelisted endpoint to be reached, but no other' do
          endpoints.each do | endpoint, is_allowed_endpoint |
            get endpoint
            if is_allowed_endpoint
              expect(response).to have_http_status(200)
            else
              expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
            end
          end
        
        end
      end
      context 'regex expression' do
        let(:endpoints) {
          {
            test_work_flow_start_step1_privilege_path => true,
            test_work_flow_complete_step1_privilege_path(success: 'true') => false,
            test_work_flow_start_step2_unprivilege_path => true,
            test_work_flow_complete_step2_unprivilege_path(success: 'true') => false,
            test_work_flow_start_step3_privilege_path => true,
            test_work_flow_complete_step3_privilege_path(success: 'true') => false,
          }
        }

        it 'allows matched endpoints to be reached, but no other' do
          endpoints.each do | endpoint, is_allowed_endpoint |
            get test_work_flow_pseudo_kiosk_start_action_path, params: { url_whitelist: "/.*start.*/" }
            get endpoint
            if is_allowed_endpoint
              expect(response).to have_http_status(200)
            else
              expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
            end
          end
        
        end

      end

      context 'multiple items' do
        let(:endpoints) {
          {
            test_work_flow_start_step1_privilege_path => true,
            test_work_flow_complete_step1_privilege_path(success: 'true') => false,
            test_work_flow_start_step2_unprivilege_path => true,
            test_work_flow_complete_step2_unprivilege_path(success: 'true') => false,
            test_work_flow_start_step3_privilege_path => true,
            test_work_flow_complete_step3_privilege_path(test: 'true') => true,
          }
        }

        it 'allows matched endpoints to be reached, but no other' do
          endpoints.each do | endpoint, is_allowed_endpoint |
            get test_work_flow_pseudo_kiosk_start_action_path, params: { url_whitelist: ["/.*start.*/", test_work_flow_complete_step3_privilege_path] }
            get endpoint
            if is_allowed_endpoint
              expect(response).to have_http_status(200), endpoint
            else
              expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
            end
          end
        
        end
      end
    end    
  end
end