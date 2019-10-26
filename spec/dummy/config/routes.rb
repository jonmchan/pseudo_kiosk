Rails.application.routes.draw do
  root to: redirect(path: 'test_work_flow/start_step1_privilege')

  get 'test_work_flow/pseudo_kiosk_start_action'
  get 'test_work_flow/pseudo_kiosk_exit_action'
  get 'test_work_flow/clear_pseudo_kiosk_session_action'

  get 'test_work_flow/start_step1_privilege'
  get 'test_work_flow/complete_step1_privilege'
  get 'test_work_flow/start_step2_unprivilege'
  get 'test_work_flow/complete_step2_unprivilege'
  get 'test_work_flow/start_step3_privilege'
  get 'test_work_flow/complete_step3_privilege'
  mount PseudoKiosk::Engine => "/"
end
