class MainController < ApplicationController
  before_action :direct_login_checker, {only: [
    :account,
    :logout_service
  ]}

  def home
  end

  def about
  end

  def services
    @service_info = Service.all
    # TODO サービス検索機能
    # search_services = Service.where("servicekeyword LIKE ?", "%#{params[:keyword]}%")
    # if search_services.present?

    # else

    # end
  end

  def appointment

  end

  def account
    if session[:user_id]
      @customer_info = Customer.find_by(userid: session[:user_id])
      appointment_info = Appointment.where(
        firstname: "#{@customer_info.firstname}",
        lastname: "#{@customer_info.lastname}",
        email: "#{@customer_info.email}"
      )
      @appointment_list = []
      appointment_info.each do |service|
        logger.info("[info]: #{service}")
        @appointment_list.push(service)
      end   
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
      params[:userid],
      params[:password],
      params[:password_confirmation]
    )
    
    if registration_flg
      session[:preuser_id] = params[:userid]
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
    user_id = session[:preuser_id]
    if params[:flg] == "done"
      session.delete(:preuser_id)
      session[:user_id] = user_id
      logger.info("[info]: 新たな顧客情報が登録されました。")
      redirect_to "/account/"
    else
      customer_info = Customer.find_by(userid: user_id)
      customer_info.destroy!
      session.delete(:preuser_id)
      logger.info("[info]: 顧客情報の登録を取り消しました。")
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
    login_hash = customer.login_checker(params[:userid], params[:password])
    login_flg = login_hash[:login_flg]
    flash.now[:notice] = login_hash[:flash_message]
    if login_flg == 5
      session[:user_id] = params[:userid]
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

  # ------お試しここから-----------------------------
  def test
    @today = Date.today
    @youbi_list = %w[日 月 火 水 木 金 土]
    end_of_this_month = Date.new(@today.year, @today.month, -1)

    @monthly_list = []
    i = 1
    week_id = 1
    last_week_id = 0
    logger.info("[ここ確認] #{end_of_this_month.day}")
    while i <= end_of_this_month.day.to_i do
      date = Date.new(@today.year, @today.month, i)
      
      month_end_day = Date.new(@today.year, @today.month, -1)
      
      if date.wday == 6
        @monthly_list_innner = [date, date.wday, week_id]
        week_id += 1
      else
        @monthly_list_innner = [date, date.wday, week_id]
      end
      @monthly_list.push(@monthly_list_innner)
      i += 1
    end
    @monthly_list.each_with_index do |day, i|
      if i == @monthly_list.size - 1
        last_week_id = day[2]
      end
    end

    @monthly_list.each do |day|
      if day[2] == last_week_id
        day[2] = 10
      end
    end
    logger.info("[test]: #{@monthly_list}")
    logger.info("[test]: #{@monthly_list_innner.size}")
  end

  def test_service
    week_id = params[:week_id]
    date_id = params[:date_id]
    youbi_id = params[:youbi_id]
    redirect_to test_2_path(date_id, youbi_id, week_id)
  end

  def test_2
    # 週の初日
    @week_start_day = 0
    # 週の最後の日
    @week_end_day = 0
    # その週の日付を格納するリスト
    @current_week_date_list = []
    youbi_id = params[:youbi_id].to_i
    date = Date.parse(params[:date_id])
    week_id = params[:week_id].to_i
    logger.info("[TEST1]:: #{week_id.class}")
    logger.info("[TEST2]:: #{date}")
    i = 0
    while i <= 6 do
      # 何曜日の?
      if youbi_id == i
        if week_id == 1
          # ここもダメ
          # logger.info("ここ通ってる？1")
          @week_start_day = Date.new(date.year, date.month, 1)
          @week_end_day = Date.new(date.year, date.month, date.day + 6 - i)
        elsif week_id == 10
          # 最後の週の空白を考慮しないとダメかも
          # logger.info("ここ通ってる？2")
          @week_start_day = Date.new(date.year, date.month, date.day - i) 
          @week_end_day = Date.new(date.year, date.month, -1)
        else
          # logger.info("ここ通ってる？3")
          @week_start_day = Date.new(date.year, date.month, date.day - i)
          @week_end_day = Date.new(date.year, date.month, date.day + 6 - i)
        end
        # logger.info("[TEST3]:ここ確認 #{@week_start_day}")
        # logger.info("[TEST4]:ここ確認 #{@week_end_day}")
        while @week_start_day.day <= @week_end_day.day do
          @current_week_date_list.push(@week_start_day)
          @week_start_day += 1
        end
      end
    end
    logger.info("[TEST5]:ここ確認 #{@current_week_date_list}")

    # カレンダー描画用
    @appointment_date_hash = {
      days: ["日", "月", "火", "水", "木", "金", "土"],
      available_time: ["10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00"],
      week_days: @current_week_date_list
    }
    logger.info("[TEST]:ここ確認 #{@appointment_date_hash[:days]}")
    logger.info("[TEST]:ここ確認 #{@appointment_date_hash[:available_time]}")
    logger.info("[TEST]:ここ確認 #{@appointment_date_hash[:week_days]}")
  end
# ------お試しここまで-----------------------------



  private
  def direct_login_checker
    if session[:user_id].blank?
      flash[:notice] = "ログインしてください。"
      redirect_to "/login/"
    end
  end
end
