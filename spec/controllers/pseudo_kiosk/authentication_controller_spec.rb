require 'rails_helper'

RSpec.describe PseudoKiosk::AuthenticationController, type: :controller do
  routes { PseudoKiosk::Engine.routes }

  pending 

  describe "GET #unlock" do
    it "returns http success" do
      get :unlock, params: {}
      expect(response).to have_http_status(:success)
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
