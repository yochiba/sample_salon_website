require 'date'

class AppointmentsController < ApplicationController
  before_action :cheat_appointment_checker, {except: [
    :appointment,
    :appointment_service
  ]}

  def appointment
    # 予約サービス情報を格納するセッション
    current_action_session = session[:appointment_service]
    # 戻るボタンを押した時、セッション内に同一キーデータが複数入るのを防ぐ
    if current_action_session.present?
      logger.info("[info]: 現在のセッションを削除しました。")
      session.delete(:appointment_service)
      session.delete(:appointment_staff)
      session.delete(:appointment_date)
      session.delete(:appointment_customer)
      logger.info("[info]: 現在の予約状況は、#{session[:appointment_service]}です。")
    end

    @services = Service.all()
  end

  def appointment_service
    appointment = Appointment.new
    appointment_service_array = appointment.get_appointment_service_array(params[:service_name])
    session[:appointment_service] = appointment_service_array[0]
    noservice_flg = appointment_service_array[1]
    if noservice_flg == 0 && session[:appointment_service].present?
      logger.info("[info]:サービス選択に成功しました。")
      logger.info("[info]: 現在のサービス予約状況は、#{session[:appointment_service]}です。")
      redirect_to appointment_staff_path
    else
      session.delete(:appointment_service)
      logger.info("[info]:サービス選択に失敗しました。")
      flash.now[:notice] = "サービスが選択されていません。"
      @services = Service.all()
      render "/appointments/appointment"
    end
  end

  def appointment_staff
    current_action_session = session[:appointment_staff]
    # 戻るボタンを押した時、セッション内に同一キーデータが複数入るのを防ぐ
    if current_action_session.present?
      logger.info("[info]: 現在のセッション内のstaff_nameを削除しました。")
      session.delete(:appointment_staff)
      logger.info("[info]: 現在のスタッフ予約状況は、#{session[:appointment_staff]}です。")
    end
    @staff_info = Staff.all
  end

  def appointment_staff_service
    appointment = Appointment.new
    appointment_staff_array = appointment.get_appointment_staff_array(params[:staff_id])

    appointment_staff_hash = appointment_staff_array[0]
    nostaff_flg = appointment_staff_array[1]
    session[:appointment_staff] = appointment_staff_hash
    if nostaff_flg == 0 && session[:appointment_staff].present?      
      logger.info("[info]:スタッフ選択に成功しました。")
      logger.info("[info]: 現在のスタッフ予約状況は、#{session[:appointment_staff]}です。")
      redirect_to appointment_date_path
    else
      flash.now[:notice] = "スタッフが選択されていません。"
      logger.info("[info]:スタッフ選択に失敗しました。")
      @staff_info = Staff.all
      render "/appointments/appointment_staff"
    end
  end

  def appointment_date
    current_action_session = session[:appointment_date]
    # 戻るボタンを押した時、セッション内に同一キーデータが複数入るのを防ぐ
    if current_action_session.present?
      logger.info("[info]: 現在のセッション内の予約時間情報を削除しました。")
      session.delete(:appointemnt_date)
      logger.info("[info]: 現在の予約状況は、#{current_action_session}です。")
    end
    appointment = Appointment.new
    # 営業時間を取得する処理
    @business_hour_hash = appointment.get_business_hour_hash
    # 3ヶ月分の日付を取得する
    @dates_hash = appointment.generate_dates_hash
    # 既存の予約情報を取得
    @existing_appointments_array = appointment.check_existing_appointment(session[:appointment_staff]["staff_id"])
    # 予約済み範囲の取得(スタッフ選択時)
    @daily_tokens_flg_hash = appointment.get_daily_tokens_flg_hash(@dates_hash, @existing_appointments_array, @business_hour_hash[:display_time], session[:appointment_service]["total_token"])
    # 予約済み範囲の最終的な結果を取得
    # (各予約間のトークン数と新規予約の合計トークン数を比較して、予約の可否を算出)
    @reserved_appointment_hash = appointment.get_final_tokens_flg_hash(@daily_tokens_flg_hash, session[:appointment_service]["total_token"])
  end

  def appointment_date_service
    # 予約スタート時間のトークンID 
    start_token_id = params[:start_token_id]
    # 予約の合計トークン数
    total_token = session[:appointment_service]["total_token"]
    # 予約の日付
    date = params[:date]
    # 今日から何日後か
    date_counter = params[:date_counter]
    # 予約スタート時間
    start_time = params[:start_time]
    # 担当スタッフID
    staff_id = session[:appointment_staff]["staff_id"]
    
    logger.info("[info]: staff_id: #{staff_id}, date:#{date} date_counter:#{date_counter}, start_time:#{start_time}, start_token_id:#{start_token_id}, total_token:#{total_token}")  
    appointment = Appointment.new
    appointment_time_hash = appointment.get_appointment_time_hash(date_counter, date, start_time, start_token_id, total_token, staff_id)
    session[:appointment_date] = appointment_time_hash





    if session[:appointment_date].present?
      logger.info("[info]: 現在の予約状況は、#{session[:appointment_date]}です。")
      redirect_to appointment_customer_info_path
    else
      flash[:notice] = "予約日時の選択でエラーが発生しました。もう一度選択してください。"
      logger.info("[info]: 現在の予約状況は、#{session[:appointment_date]}です。")
      # redirect_to appointment_date_path
      render "/appointments/appointment_date"
    end
  end

  def appointment_customer_info
    # ログイン済みユーザー判別処理
    if session[:user_id]
      @customer_info = Customer.find_by(userid: session[:user_id])
    end
  end

  def appointment_customer_info_service
    appointment = Appointment.new
    # ログイン済みユーザー判別処理
    if session[:user_id]
      customer_info = Customer.find_by(userid: session[:user_id])
      appointment_customer_hash = appointment.get_appointment_customer_hash(customer_info.firstname, customer_info.lastname, customer_info.email)
    else
      appointment_customer_hash = appointment.get_appointment_customer_hash(params[:firstname], params[:lastname], params[:email])
    end
    session[:appointment_customer] = appointment_customer_hash

    if session[:appointment_customer].present?
      redirect_to appointment_confirmation_path
    else
      flash[:notice] = "お客様情報の確認に失敗しました。もう一度ご記入ください。"
      render "main/appointment_customer_info"
    end
  end

  def appointment_confirmation
    @appointment_info_hash = {}
    @appointment_info_hash[:氏名] = "#{session[:appointment_customer]["lastname"]} #{session[:appointment_customer]["firstname"]}"
    @appointment_info_hash[:Email] = "#{session[:appointment_customer]["email"]}"
    @appointment_info_hash[:選択したメニュー] = "#{session[:appointment_service]["service_names"]}"
    @appointment_info_hash[:担当スタッフ] = "#{session[:appointment_staff]["staff_name"]}"
    @appointment_info_hash[:予約日時] = "#{session[:appointment_date]["display_start_date"]} #{session[:appointment_date]["display_start_time"]}"
    @appointment_info_hash[:施術時間] = "#{session[:appointment_date]["total_time"]}分"
    @appointment_info_hash[:金額] = "#{session[:appointment_service]["total_service_price"]}円"
  end

  def appointment_confirmation_service
    logger.info("[info]: #{session[:appointment_customer]}")
    logger.info("[info]: 予約日時:#{session[:appointment_date]["start_date"]}")
    appointment_info = Appointment.new(
      firstname: session[:appointment_customer]["firstname"],
      lastname: session[:appointment_customer]["lastname"],
      email: session[:appointment_customer]["email"],
      servicename: session[:appointment_service]["service_names"],
      startdate: session[:appointment_date]["start_date"],
      starttime: session[:appointment_date]["start_time"],
      staffid: session[:appointment_staff]["staff_id"],
      staffname: session[:appointment_staff]["staff_name"],
      totalservicetime: session[:appointment_date]["total_time"],
      totalserviceprice: session[:appointment_service]["total_service_price"],
      totaltoken: session[:appointment_service]["total_token"],
      starttokenid: session[:appointment_date]["start_token_id"],
      displaydate: session[:appointment_date]["display_date"],
      displaystartdate: session[:appointment_date]["display_start_date"],
      displaystarttime: session[:appointment_date]["display_start_time"],
      past_flg: 0
    )
    if appointment_info.valid?
      appointment_info.save!
      logger.info("[info]: #{session[:appointment_date]["start_date"]}")
      redirect_to appointment_complete_path
    else
      flash[:notice] = "予約に失敗しました。もう一度やり直してください。"
      # session.delete(:appointment_service)
      # session.delete(:appointment_staff)
      # session.delete(:appointment_date)
      # session.delete(:appointment_customer)
      render "/main/home"
    end
  end

  def appointment_complete
    # session.delete(:appointment_service)
    # session.delete(:appointment_staff)
    # session.delete(:appointment_date)
    # session.delete(:appointment_customer)
  end

  # 予約キャンセルおよび予約途中での破棄の役割
  def appointment_delete_service
    session.delete(:appointment_service)
    session.delete(:appointment_staff)
    session.delete(:appointment_date)
    session.delete(:appointment_customer)
    logger.info("[info]: 現在の予約状況は、#{session[:appointment_date]}です。")
    flash[:notice] = "手続き中の予約を取り消しました。"
    redirect_to appointment_path
  end
  
  # 予約処理の途中から入ってしまうのを防ぐ
  private
  def cheat_appointment_checker
    if session[:appointment_service].blank?
      flash[:notice] = "予約内容を選択してください"
      redirect_to appointment_path
    end
  end

  # def appointment_session_delete
  #   if session.delete(:appointment_service).present? || session.delete(:appointment_staff).present? || session.delete(:appointment_date).present? || session.delete(:appointment_customer).present?
  #     session.delete(:appointment_service)
  #     session.delete(:appointment_staff)
  #     session.delete(:appointment_date)
  #     session.delete(:appointment_customer)
  #   end
  # end
end
