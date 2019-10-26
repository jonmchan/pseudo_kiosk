require 'rails_helper'

RSpec.describe PseudoKiosk::AuthenticationController, type: :controller do
  routes { PseudoKiosk::Engine.routes } 

  describe "GET #unlock" do
    context 'when pseudo_kiosk is enabled' do
      before do
        session[:pseudo_kiosk_enabled] = true
        session[:pseudo_kiosk_whitelist] = nil
        session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = nil
      end
      it "returns http success" do
        get :unlock, params: {}
        expect(response).to have_http_status(:success)
      end
    end
    context 'when pseudo_kiosk is disabled' do
      it "returns http success" do
        get :unlock, params: {}
        expect(response).to redirect_to('/')
      end
    end
  end

  describe "GET #process_submit" do
    before do
      session[:pseudo_kiosk_enabled] = true
      session[:pseudo_kiosk_whitelist] = nil
      session[:pseudo_kiosk_unauthorized_endpoint_redirect_url] = nil
      session[:pseudo_kiosk_unlock_redirect_url] = '/success_unlock'
    end
    context 'when config.unlock_mechanism is unset' do
      before do
        PseudoKiosk::Config.reset!
      end
      it 'raises an exception' do
        expect { post :process_submit, params: { passphrase: '123' } }.to raise_exception('PseudoKiosk::Config.unlock_mechanism is missing!')
      end
    end

    context 'when config.unlock_mechanism is a string' do
      before do
        PseudoKiosk::Config.unlock_mechanism = '123'
      end
      context 'when password string matches' do
        before do
          post :process_submit, params: { passcode: '123' }
        end

        it 'redirects to pseudo_kiosk_unlock_redirect_url' do
          expect(response).to redirect_to('/success_unlock')
        end

        it 'clears the pseudo_kiosk session' do
          expect(session[:pseudo_kiosk_enabled]).to be_nil
          expect(session[:pseudo_kiosk_whitelist]).to be_nil
          expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
          expect(session[:pseudo_kiosk_unlock_redirect_url]).to be_nil
        end
      end

      context 'when password string does not match' do
        before do
          post :process_submit, params: { passcode: 'badwolf' }
        end

        it 'redirects to unlock with failed=true' do
          expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path + '?failed=true')
        end

        it 'does not clears the pseudo_kiosk session' do
          expect(session[:pseudo_kiosk_enabled]).to eql(true)
          expect(session[:pseudo_kiosk_whitelist]).to be_nil
          expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
          expect(session[:pseudo_kiosk_unlock_redirect_url]).to eql('/success_unlock')
        end
      end
    end

    context 'when config.unlock_mechanism is a lambda function' do
      before do
        session[:test_passcode] = "swordfish"
        PseudoKiosk::Config.unlock_mechanism = ->(controller_context, params) {
          return controller_context.session[:test_passcode] == params[:passcode] ? true : false
        }
      end
      context 'when lambda returns true' do
        before do
          post :process_submit, params: { passcode: 'swordfish' }
        end

        it 'redirects to pseudo_kiosk_unlock_redirect_url' do
          expect(response).to redirect_to('/success_unlock')
        end

        it 'clears the pseudo_kiosk session' do
          expect(session[:pseudo_kiosk_enabled]).to be_nil
          expect(session[:pseudo_kiosk_whitelist]).to be_nil
          expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
          expect(session[:pseudo_kiosk_unlock_redirect_url]).to be_nil
        end
      end

      context 'when lambda returns false' do
        before do
          post :process_submit, params: { passcode: 'badwolf' }
        end

        it 'redirects to unlock with failed=true' do
          expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path + '?failed=true')
        end

        it 'does not clears the pseudo_kiosk session' do
          expect(session[:pseudo_kiosk_enabled]).to eql(true)
          expect(session[:pseudo_kiosk_whitelist]).to be_nil
          expect(session[:pseudo_kiosk_unauthorized_endpoint_redirect_url]).to be_nil
          expect(session[:pseudo_kiosk_unlock_redirect_url]).to eql('/success_unlock')
        end
      end
    end

  end

end
