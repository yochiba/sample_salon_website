class StaffsController < ApplicationController
  before_action :direct_access_checker, {except: [
    :staff_login,
    :staff_login_service
  ]}

  before_action :session_checker, {only: [
    :staff_login
  ]}

  def staff_account

  end

  def staff_login
    if session[:staff_id].present?
      redirect_to staff_login_path
    end
  end

  def staff_login_service
    staff_info = Staff.new
    login_hash = staff_info.login_checker(params[:staff_id], params[:password])
    login_flg = login_hash["login_flg"]
    if login_flg == 0
      session[:staff_id] = params[:staff_id]
      redirect_to staff_account_path
    else
      logger.info("[info]: ログインに失敗しました。原因は#{login_flg}です。")
      flash.now[:notice] = login_hash["flash_message"]
      render "/staffs/login/"
    end
  end

  def staff_shift
    staff_info = Staff.new
    @monthly_dates_hash = staff_info.check_schedule(session[:staff_id])
  end

  def staff_vacation

  end

  def staff_logout_service
    session.delete(:staff_id)
    redirect_to staff_login_path
  end

  private
  def session_checker
    if session[:staff_id]
      redirect_to staff_account_path
    end
  end

  def direct_access_checker
    if session[:staff_id].blank?
      flash[:notice] = "ログインしてください"
      redirect_to staff_login_path
    end
  end
end
