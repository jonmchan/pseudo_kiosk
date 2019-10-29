require 'rails_helper'

def validate_endpoints(endpoints)
  endpoints.each do | endpoint, is_allowed_endpoint |
    get endpoint
    if is_allowed_endpoint
      expect(response).to_not redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
      expect(response).to_not redirect_to(test_work_flow_start_step2_unprivilege_path)
    else
      expect(response).to redirect_to(test_work_flow_start_step2_unprivilege_path)
    end
  end
end

def validate_require_passcode_for_all(endpoints)
  endpoints.each do |endpoint, is_allowed_endpoint|
    get endpoint
    if is_allowed_endpoint
      expect(response.code).to eql("200")
    else
      expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
    end
  end
end


describe 'Integration - Privileged/Unprivileged Workflow Scenario', type: :request do
  before(:all) do
    pseudo_kiosk_reload!
    PseudoKiosk::Config.unlock_mechanism = "passcode"
  end

  let(:privilege_state_endpoints) {
    {
      test_work_flow_start_step1_privilege_path => true,
      test_work_flow_complete_step1_privilege_path => true,
      test_work_flow_start_step2_unprivilege_path => true,
      test_work_flow_complete_step2_unprivilege_path => true,
      test_work_flow_start_step3_privilege_path => true,
      test_work_flow_complete_step3_privilege_path => true,
      test_work_flow_complete_step3_privilege_path(success: 'true') => true,
    }
  }

  let(:unprivilege_state_endpoints) {
    {
      test_work_flow_start_step1_privilege_path => false,
      test_work_flow_complete_step1_privilege_path(success: 'true') => false,
      test_work_flow_start_step2_unprivilege_path => true,
      test_work_flow_complete_step2_unprivilege_path => true,
      test_work_flow_start_step3_privilege_path => false,
      test_work_flow_complete_step3_privilege_path(success: 'true') => false,
    }
  }

  let(:passcode_lockdown_endpoints) {
    {
      PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path => true,
      test_work_flow_complete_step1_privilege_path(success: 'true') => false,
      test_work_flow_start_step2_unprivilege_path => false,
      test_work_flow_complete_step2_unprivilege_path => false,
      test_work_flow_start_step3_privilege_path => false,
      test_work_flow_complete_step3_privilege_path(success: 'true') => false,
      test_work_flow_start_step1_privilege_path => false,
    }
  }

  it 'properly secures privilege/unprivileged endpoints during workflow' do
    # Step 1 in privileged state
    # all endpoints should be accessible
    validate_endpoints(privilege_state_endpoints)

    # Enter step 2, unprivileged state
    get test_work_flow_complete_step1_privilege_path(success: 'true')
    expect(response).to redirect_to(test_work_flow_start_step2_unprivilege_path)

    # only unprivileged endpoints should be accessible
    validate_endpoints(unprivilege_state_endpoints)

    # Complete step 2
    get test_work_flow_complete_step2_unprivilege_path(success: 'true')
    expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path)
    follow_redirect!

    # nothing should be allowed now since we are in require passcode state
    validate_require_passcode_for_all(passcode_lockdown_endpoints)

    # enter wrong passcode
    post PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_process_submit_path, params: { passcode: 'pass' }
    expect(response).to redirect_to(PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_unlock_path(failed:'true'))


    # enter correct passcode
    post PseudoKiosk::Engine.routes.url_helpers.pseudo_kiosk_authentication_process_submit_path, params: { passcode: 'passcode' }
    # we expect redirect to the last visited url which is step1 in endpoints_after_step2
    expect(response).to redirect_to(test_work_flow_start_step1_privilege_path)

    # we are in privileged state again, we should be able to visit all endpoints
    validate_endpoints(privilege_state_endpoints)
  end
end
