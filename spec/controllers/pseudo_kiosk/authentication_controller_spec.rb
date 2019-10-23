require 'rails_helper'

RSpec.describe PseudoKiosk::AuthenticationController, type: :controller do
  routes { PseudoKiosk::Engine.routes }

  describe "GET #unlock" do
    it "returns http success" do
      get :unlock, params: {}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #process_submit" do
    it "returns http success" do
      get :process_submit, params: {}
      expect(response).to have_http_status(:success)
    end
  end

end
