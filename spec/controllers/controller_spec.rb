require 'rails_helper'


describe TestWorkFlowController, type: :controller do
  before(:all) do
    pseudo_kiosk_reload!
  end

  describe 'injected methods' do
    it { is_expected.to respond_to(:secure_pseudo_kiosk) }
    it { is_expected.to respond_to(:pseudo_kiosk_start) }
    it { is_expected.to respond_to(:pseudo_kiosk_exit) } 
    it { is_expected.to respond_to(:clear_pseudo_kiosk_session) }
  end

  describe '#secure_pseudo_kiosk' do
    context 'when pseudo_kiosk is enabled' do
      context 'when in url_whitelist' do
        before do
          get :pseudo_kiosk_start_action, params: { url_whitelist: ['//test_work_flow/pseudo_kiosk.*/'] }
        end
        it 'allows endpoint to be loaded' do
          get :pseudo_kiosk_start_action

          expect(response.status).to eql(200)
        end
      end
      context 'when url is not in whitelist' do
        context 'when unauthorized_endpoint_redirect_url is set' do
          before do
            session[:pseudo_kiosk_enabled] = true
            session[:pseudo_kiosk_whitelist] = /\/test_work_flow\/pseudo_kiosk.*/
            session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = test_work_flow_start_step2_unprivilege_path

            get :start_step1_privilege
          end
          it 'redirects to unauthorized_endpoint_redirect_url' do
            expect(response).to redirect_to(test_work_flow_start_step2_unprivilege_path)
          end
          it 'does not change unauthorized_endpoint_redirect_url in session' do
            expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to eql(test_work_flow_start_step2_unprivilege_path)
          end

          it 'does not set the pseudo_kiosk_unlock_redirect_url' do
            expect(session[:pseudo_kiosk_unlock_redirect_url]).to be_nil
          end
        end
        context 'when unauthorized_endpoint_redirect_url is nil' do
          before do
            session[:pseudo_kiosk_enabled] = true
            session[:pseudo_kiosk_whitelist] = /\/test_work_flow\/pseudo_kiosk.*/
            session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = nil

            get :start_step1_privilege
          end
          it 'redirects to unauthorized_endpoint_redirect_url' do
            expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
          end
          it 'does not change unauthorized_endpoint_redirect_url in session' do
            expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
          end

          it 'does sets the pseudo_kiosk_unlock_redirect_url' do
            expect(session[:pseudo_kiosk_unlock_redirect_url]).to eql(test_work_flow_start_step1_privilege_path)
          end
        end
      end
    end
    context 'when pseudo_kiosk is disabled' do
      # can only test 1 single endpoint here because of controller spec limitation,
      # the expanded tests are in the core_functions request spec.

      before do
        session[:pseudo_kiosk_enabled] = nil

        get :start_step3_privilege
      end

      it "allows endpoint to be hit" do
        expect(response.status).to eql(200)
      end
    end

    # check request spec folder for whitelist tests;
    # need to utilize ability to simulate multiple http requests

    # describe 'whitelist tests' do end
  end

  describe '#pseudo_kiosk_start' do
    context 'when unauthorized_endpoint_redirect_url is nil' do 
      before do 
        get :pseudo_kiosk_start_action, { params: { url_whitelist: ['test1', "/testhi/" ] } }
      end
      it 'sets the session variables correctly' do
        expect(session[:pseudo_kiosk_enabled]).to eql(true)
        expect(session[:pseudo_kiosk_whitelist]).to contain_exactly('test1', /testhi/)
        expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
      end
    end

    context 'when unauthorized_endpoint_redirect_url is nil' do 
      before do 
        get :pseudo_kiosk_start_action, { params: { url_whitelist: ['test1', "/testhi/" ], unauthorized_endpoint_redirect_url: test_work_flow_start_step2_unprivilege_path } }
      end
      it 'sets the session variables correctly' do
        expect(session[:pseudo_kiosk_enabled]).to eql(true)
        expect(session[:pseudo_kiosk_whitelist]).to contain_exactly('test1', /testhi/)
        expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to eql(test_work_flow_start_step2_unprivilege_path)
      end
    end
  end

  describe '#pseudo_kiosk_exit' do
    before do 
      session[:pseudo_kiosk_enabled] = true
      session[:pseudo_kiosk_whitelist] = [ test_work_flow_pseudo_kiosk_exit_action_path ]
      session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = "somewhere"
      session[:pseudo_kiosk_unlock_redirect_url] = "bllahlba"
      
      get :pseudo_kiosk_exit_action, params: { unlock_redirect_url: test_work_flow_start_step1_privilege_path }
    end

    it 'sets the unlock_redirect_url to the passed in value' do
      expect(session[:pseudo_kiosk_unlock_redirect_url]).to eql(test_work_flow_start_step1_privilege_path)
    end

    it 'clears the whitelist' do
      expect(session[:pseudo_kiosk_whitelist]).to be_nil
    end

    it 'redirects to the unlock page' do 
      expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
    end
  end

  describe '#clear_pseudo_kiosk_session' do
    context 'when pseudo_kiosk session does not exist' do
      it 'does not break' do
        get :clear_pseudo_kiosk_session_action

        expect(session[:pseudo_kiosk_enabled]).to be_nil
        expect(session[:pseudo_kiosk_whitelist]).to be_nil
        expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
        expect(session[:pseudo_kiosk_unlock_redirect_url]).to be_nil
      end
    end

    context 'when pseudo_kiosk session exists' do
      before do
        session[:pseudo_kiosk_enabled] = true
        session[:pseudo_kiosk_whitelist] = [ test_work_flow_clear_pseudo_kiosk_session_action_path ]
        session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = "somewhere"
        session[:pseudo_kiosk_unlock_redirect_url] = "bllahlba"
      end

      it 'clears the session' do
        get :clear_pseudo_kiosk_session_action

        expect(session[:pseudo_kiosk_enabled]).to be_nil
        expect(session[:pseudo_kiosk_whitelist]).to be_nil
        expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
        expect(session[:pseudo_kiosk_unlock_redirect_url]).to be_nil
      end

    end
  end
end
