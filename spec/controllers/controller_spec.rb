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
end
