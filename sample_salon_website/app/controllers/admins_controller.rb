require "admin.rb"

class AdminsController < ApplicationController
  before_action :direct_login_checker, {only: [
    :admin_account,
    :admin_manage,
    :admin_add,
    :admin_edit,
    :admin_delete,
    :admin_logout
  ]}

  before_action :staff_add_validation, {only: [
    :admin_manage_staff_add_confirmation
  ]}

  def admin_login
    if session[:admin_id].present?
      redirect_to admin_account_path
    end
  end

  def admin_login_service
    admin_info = Admin.new
    login_check_hash = admin_info.login_checker(params[:admin_id], params[:password])
    login_flg = login_check_hash["login_flg"]
    flash.now[:notice] = login_check_hash["flash_message"]

    if login_flg == 4
      logger.info("[info]: ログインに成功しました。")
      session[:admin_id] = params[:admin_id]
      redirect_to admin_account_path
    else
      logger.info("[info]: ログインに失敗しました。原因は#{login_flg}です。")
      render "/admins/admin_login"
    end
  end

  def admin_account
    @admin_info = Admin.find_by(adminid: session[:admin_id])
  end

  def admin_manage
    @admin_info = Admin.find_by(adminid: session[:admin_id])
    @other_admin_info = Admin.all
  end

  def admin_add
  end

  def admin_add_service
    admin = Admin.new
    #TODO MVCを意識するならこれでいいけど、無駄かも？コントローラーに直書きでもいい気がする
    registration_flg = admin.admin_registration?(
      params[:firstname],
      params[:lastname],
      params[:email],
      params[:admin_id],
      params[:password],
      params[:password_confirmation]
    )
    
    if registration_flg
      session[:preuser_id] = params[:user_id]
      logger.info("[info]: 新たな管理者情報が登録されました。確認画面へ進みます。")
      redirect_to admin_manage_path
    else
      logger.info("[info]: 管理者情報の登録に失敗しました。 ")
      flash.now[:notice] = "管理者情報登録に失敗しました。"
      render "/admins/admin_add"
    end
  end

  def admin_edit
    @this_admin_info = Admin.find_by(adminid: params[:admin_id])
  end

  def admin_edit_service
    # FIXME view側での編集方法考える
    # 例えば、確認画面を追加するのか編集画面で全て住めせてしまうのか。
    # 編集に必要な情報など要検討

    admin_edit_info = Admin.new
    admin_edit_hash = admin_edit_info.admin_edit_handler(params[:edited_lastname], params[:edited_firstname], params[:edited_email], params[:edited_admin_id])
    session[:edited_admin_info] = admin_edit_hash

    if session[:edited_admin_info].present?
      redirect_to admin_edit_confirmation_path
    else
      flash[:notice] = "管理者の編集に失敗しました。"
      render "/main/admin_edit/#{params[:admin_id]}"
    end
  end

  def admin_edit_confirmation
    
  end

  def admin_edit_confirmation_service
    super_admin = Admin.find_by(adminid: session[:admin_id])

  end

  def admin_delete
    @this_admin_info = Admin.find_by(adminid: params[:admin_id])
    
  end

  def admin_delete_service
    # TODO 失敗の理由を判別する処理を追加
    # TODO セッションのみで判別できるようにする
    if session[:admin_id]
      admin_info = Admin.find_by(adminid: session[:admin_id])
    else
      admin_info = Admin.find_by(adminid: params[:admin_id])
    end

    if admin_info.present? && params[:password].present? && admin_info.authenticate(params[:password])
      other_admin_info = Admin.find_by(adminid: params[:admin_id])
      if other_admin_info.present?
        flash.now[:notice] = "管理者[#{other_admin_info.adminid}]を削除しました"
        other_admin_info.destroy!
        redirect_to admin_manage_path
      end
    else
      flash.now[:notice] = "管理者の削除に失敗しました。"
      @this_admin_info = Admin.find_by(adminid: params[:admin_id])
      render "/admins/admin_delete"
    end
  end

  def admin_manage_appointment
    @appointment_info = Appointment.where(past_flg: 0).order(startdate: "DESC")
  end

  def admin_manage_appointment_service
    appointment_info = Appointment.find_by(id: params[:appointment_id])
    appointment_info.update(past_flg: 1)
    redirect_to admin_manage_appointment_path
  end

  def admin_manage_contact
    @contact_info = Contact.all
  end

  def admin_manage_staff
    @staffs = Staff.all
  end

  def admin_manage_staff_shift
    @staff_info = Staff.find_by(id: params[:staff_id])
    appointments_info = Appointment.new
    @staff_shift_array = appointments_info.staff_shift_manager(params[:staff_id])
  end

  def admin_manage_staff_add
  end

  def admin_manage_staff_add_service
    staff = Staff.new
    staff_info_hash = staff.get_staff_info_hash(
      params[:lastname],
      params[:firstname],
      params[:staff_id],
      params[:display_name],
      params[:email],
      params[:password], 
      params[:password_confirmation]
    )
    if staff_info_hash["error_message"].blank?
      session[:staff_info] = staff_info_hash
      redirect_to admin_manage_staff_add_confirmation_path
    else
       flash[:notice] = staff_info_hash["error_message"]
       redirect_to admin_manage_staff_add_path
    end
  end

  def admin_manage_staff_add_confirmation
  end

  def admin_manage_staff_add_confirmation_service
    if params[:flg] == "done"
      staff = Staff.new
      registered_flg = staff.staff_registrator(session[:staff_info])
      session.delete(:staff_info)
      if registered_flg
        flash[:notice] = "スタッフ登録が完了しました。"
      else
        flash[:notice] = "スタッフ登録に失敗しました。"
      end
    else
      session.delete(:staff_info)
      flash[:notice] = "スタッフ登録を取り消しました。"
    end
    redirect_to admin_manage_staff_path
  end

  def admin_logout_service
    session.delete(:service)
    session.delete(:admin_id)
    redirect_to admin_login_path
  end

  private
  def direct_login_checker
    if session[:admin_id].blank?
      flash[:notice] = "ログインしてください。"
      redirect_to admin_login_path
    end
  end

  def staff_add_validation
    if session[:staff_info].blank?
      flash[:notice] = "スタッフ情報を入力してください。"
      redirect_to admin_manage_staff_add_path
    end
  end
end
