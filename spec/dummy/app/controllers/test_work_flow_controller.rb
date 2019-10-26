class TestWorkFlowController < ApplicationController
  def pseudo_kiosk_start_action
    whitelist = params[:url_whitelist]
    if whitelist.is_a? Array
      whitelist.map! do |url|
        if regex = url.match(/^\/(.*)\/$/)&.[](1)
          /#{regex}/
        else
          url
        end
      end
    else
      if regex = whitelist&.match(/^\/(.*)\/$/)&.[](1)
        whitelist = /#{regex}/
      end
    end
    pseudo_kiosk_start(whitelist, params[:unauthorized_endpoint_redirect_url])
    render json: "OK"
  end

  def pseudo_kiosk_exit_action
    pseudo_kiosk_exit(params[:unlock_redirect_url])
  end

  def clear_pseudo_kiosk_session_action
    clear_pseudo_kiosk_session
    render json: "OK"
  end


  # test/example workflow
  def start_step1_privilege
  end

  def complete_step1_privilege
    if params[:success] == "true"
      pseudo_kiosk_start([ test_work_flow_start_step2_unprivilege_path, test_work_flow_complete_step2_unprivilege_path ], test_work_flow_start_step2_unprivilege_path)
      redirect_to test_work_flow_start_step2_unprivilege_path
    else
      redirect_to test_work_flow_start_step1_privilege_path(missing_param: "true")
    end
  end

  def start_step2_unprivilege
  end

  def complete_step2_unprivilege
    if params[:success] == "true"
      pseudo_kiosk_exit(test_work_flow_start_step3_privilege_path)
    else
      redirect_to test_work_flow_start_step2_unprivilege_path(missing_param: "true")
    end
  end

  def start_step3_privilege
  end

  def complete_step3_privilege
    if params[:test] == "true"
      render json: 'OK'
    elsif params[:success] == "true"
      redirect_to test_work_flow_start_step3_privilege_path
    else
      redirect_to test_work_flow_start_step3_privilege_path(missing_param: "true")
    end
  end
end
