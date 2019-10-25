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
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #process_submit" do
    context 'when config.unlock_mechanism is a string' do
      context 'when password string matches' do

        it "returns http success" do
          post :process_submit, params: {}
          expect(response).to have_http_status(:success)
        end
      end

      context 'when password string does not match' do

      end
    end

    context 'when config.unlock_mechanism is a lambda function' do
      context 'when lambda returns true' do

      end

      context 'when lambda returns false' do

      end
    end

  end

end
