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

  def admin_login
    if session[:admin_id].present?
      redirect_to "/admin_account"
    end
  end

  def admin_login_service
    admin = Admin.new
    login_check_hash = admin.login_checker(params[:admin_id], params[:password])
    login_flg = login_check_hash[:login_flg]
    flash.now[:notice] = login_check_hash[:flash_message]

    if login_flg == 4
      logger.info("ログインに成功しました。")
      session[:admin_id] = params[:admin_id]
      redirect_to "/admin_account"
    else
      logger.info("ログインに失敗しました。原因は#{login_flg}です。")
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
    admin_info = Admin.new(
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email],
      adminid: params[:adminid],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if admin_info.valid?
      admin_info.save!
      flash.now[:notice] = "ユーザーを追加しました。"
      redirect_to "/admin_manage"
    else
      flash.now[:notice] = "ユーザー追加に失敗しました。"
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

    admin_info = Admin.find_by(adminid: params[:admin_id])

    session[:edited_admin_info] = nil
    if params[:edited_lastname].present? && params[:edited_lastname] != admin_info.lastname
      session[:edited_admin_info][:edited_lastname] = params[:edited_lastname]
    end

    if params[:edited_firstname].present? && params[:edited_firstname] != admin_info.firstname
      session[:edited_admin_info][:edited_firstname] = params[:edited_firstname]
    end

    if params[:edited_email].present? && params[:edited_email] != admin_info.email
      session[:edited_admin_info][:edited_email] = params[:edited_email]
    end

    if params[:edited_admin_id].present? && params[:edited_admin_id] != admin_info.admin_id
      session[:edited_admin_info][:edited_admin_id] = params[:edited_admin_id]
    end
    # パスワード編集処理
    # if edited_password.present? && edited_lastname != admin_info.lastname
    # end

    if session[:edited_admin_info].present?
      redirect_to admin_edit_confirmation_path
    else
      flash[:notice] = "管理者の編集に編失敗しました。"
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
        redirect_to "/admin_manage"
      end
    else
      flash.now[:notice] = "管理者の削除に失敗しました。"
      @this_admin_info = Admin.find_by(adminid: params[:admin_id])
      render "/admins/admin_delete"
    end
  end

  def admin_manage_appointment
    @appointment_info = Appointment.all
  end

  def admin_manage_contact
    @contact_info = Contact.all
  end

  def admin_logout_service
    session.delete(:service)
    session.delete(:admin_id)
    redirect_to "/admin_login/"
  end

  private
  def direct_login_checker
    if session[:admin_id].blank?
      flash[:notice] = "ログインしてください。"
      redirect_to "/admin_login/"
    end
  end
end
