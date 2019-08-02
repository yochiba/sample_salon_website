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
    #TODO MVCを意識するならこれでいいけど、無駄かも？コントローラーに直書きでもいい気がする
    registration_flg = customer.customer_registration?(
      params[:firstname],
      params[:lastname],
      params[:age],
      params[:gender],
      params[:email],
      params[:user_id],
      params[:password],
      params[:password_confirmation]
    )
    
    if registration_flg
      session[:preuser_id] = params[:user_id]
      logger.info("[info]: 新たな顧客情報が登録されました。確認画面へ進みます。")
      redirect_to "/registration_confirmation/"
    else
      logger.info("[info]: 顧客情報の登録に失敗しました。 ")
      flash.now[:notice] = "ユーザー情報登録に失敗しました。"
      render "/main/registration/"
    end
  end

  def registration_confirmation
    # 確認画面での情報確認用
    @customer_info = Customer.find_by(userid: session[:preuser_id])
  end

  def registration_confirmation_service
    if params[:flg] == "done"
      customer_info = Customer.find_by(userid: session[:preuser_id])
      logger.info("[DEBUG] #{customer_info}")
      logger.info("[DEBUG] #{customer_info}")
      session[:user_id] = session[:preuser_id]
      session.delete(:preuser_id)
      logger.info("[info]: 新たな顧客情報が登録されました。")
      redirect_to "/account/"
    else
      flash[:notice] = "顧客情報の登録を取り消しました。"
      redirect_to "/registration/"
    end
  end

  def login
    if session[:user_id].present?
      redirect_to "/account"
    end
  end

  def login_service
    customer = Customer.new
    login_hash = customer.login_checker(params[:user_id], params[:password])
    login_flg = login_hash[:login_flg]
    flash.now[:notice] = login_hash[:flash_message]
    if login_flg == 0
      session[:user_id] = params[:user_id]
      redirect_to "/account/"
    else
      logger.info("ログインに失敗しました。原因は#{login_flg}です。")
      render "/main/login/"
    end
  end

  def logout_service
    session.delete(:user_id)
    redirect_to "/login/"
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
      redirect_to "/contact"
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
      redirect_to "/login/"
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