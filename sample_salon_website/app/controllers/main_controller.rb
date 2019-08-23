class MainController < ApplicationController
  before_action :direct_login_checker, {only: [
    :account,
    :logout_service
  ]}
  before_action :unauthorized_user_delete, {except: [
    :account,
    :registration_confirmation,
    :registration_confirmation_service
  ]}

  def home
  end

  def about
  end

  def services
    @service_info = Service.all
    # TODO サービス検索機能
  end

  def appointment

  end

  def account
    if session[:user_id]
      customer = Customer.new
      @customer_info = customer.get_user_account(session[:user_id])
      @appointment_list = customer.get_appointment_info(@customer_info.firstname, @customer_info.lastname, @customer_info.email)
      @past_appointment_list = customer.get_past_appointment_info(@customer_info.firstname, @customer_info.lastname, @customer_info.email)
    end
  end

  def registration
  end

  def registration_service
    customer = Customer.new
    customer_info_hash = customer.get_customer_info_hash(
      params[:lastname],
      params[:firstname],
      params[:age],
      params[:gender],
      params[:email],
      params[:user_id],
      params[:password],
      params[:password_confirmation]
    )
    if customer_info_hash["error_message"].blank?
      session[:customer_info] = customer_info_hash
      redirect_to registration_confirmation_path
    else
       flash[:notice] = customer_info_hash["error_message"]
       redirect_to registration_path
    end
  end

  def registration_confirmation
    
  end

  def registration_confirmation_service
    if params[:flg] == "done"  
      customer = Customer.new
      registered_flg = customer.customer_registrator(session[:customer_info])
      session.delete(:customer_info)
      if registered_flg
        flash[:notice] = "ユーザー登録が完了しました。"
      else
        flash[:notice] = "ユーザー登録に失敗しました。"
      end
    else
      session.delete(:customer_info)
      flash[:notice] = "ユーザー登録を取り消しました。"
    end
    redirect_to registration_path
  end

  def login
    if session[:user_id].present?
      redirect_to account_path
    end
  end

  def login_service
    customer = Customer.new
    login_hash = customer.login_checker(params[:user_id], params[:password])
    login_flg = login_hash["login_flg"]
    flash.now[:notice] = login_hash["flash_message"]
    if login_flg == 0
      session[:user_id] = params[:user_id]
      redirect_to account_path
    else
      logger.info("[info]: ログインに失敗しました。原因は#{login_flg}です。")
      render "/main/login/"
    end
  end

  def logout_service
    session.delete(:user_id)
    redirect_to login_path
  end

  def contact
  end

  def contact_service
    contact_info = Contact.new(
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email],
      message: params[:message]
    )
    if contact_info.valid?
      contact_info.save!
      flash[:notice] = "お問い合わせが完了しました。"
      logger.info("[info]: お問い合わせを受け取りました。")
      redirect_to contact_path
    else
      flash.now[:notice] = "お問い合わせの送信に失敗しました。"
      logger.info("[info]: お問い合わせの送信に失敗しました。")
      render "/main/contact"
    end
  end
  
  private
  def direct_login_checker
    if session[:user_id].blank?
      flash[:notice] = "ログインしてください。"
      redirect_to login_path
    end
  end

  def unauthorized_user_delete
    unauthorized_users = Customer.find_by(userid: session[:preuser_id])
    if unauthorized_users.present? && session[:preuser_id].present?
      unauthorized_users.destroy
      session.delete(:preuser_id)
      logger.info("[info]: 顧客情報の登録を取り消しました。")
    end
  end
end