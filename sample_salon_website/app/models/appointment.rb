require 'date'

class Appointment < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :servicename, presence: true
  validates :startdate, presence: true
  validates :enddate, presence: true
  validates :staffid, presence: true
  validates :staffname, presence: true
  validates :totalservicetime, presence: true
  validates :totalserviceprice, presence: true
  validates :totaltoken, presence: true
  validates :starttokenid, presence: true
  # validates :displaydate, presence: true
  

  # 始業時間
  @@business_open_hour = 10
  # 就業時間
  @@business_close_hour = 19
  # トークン単位(30分/1トークン)
  @@token_icon = 30

  # 予約メニュー選択処理
  # appointment_service_path
  def get_appointment_service_list(service_name)
    appointment_service_list = []
    appointment_service_hash = {}
    noservice_flg = 0
    # サービスを選択せずに進んだ時の処理
    if service_name.nil?
      @services = Service.all()
      logger.info("[info]: サービスが選択されていません。")
      noservice_flg = 1
    end
    
    if noservice_flg == 0
      logger.info("[info]: 選択されたサービスは#{service_name}です。")
      # 施術トークン計算用(DBには格納しない)
      total_service_time = 0
      # 合計施術トークン数
      total_token = 0
      total_service_price = 0
      service_name.each do |service|
        logger.info("[info]: servicenameは、#{service}です。")
        # サービスの合計施術時間と合計金額を計算
        service_info = Service.find_by(servicename: service)
        total_service_time += service_info.servicetime
        total_service_price += service_info.serviceprice
        # 予約時間トークン数を計算
        if total_service_time % @@token_icon == 0
          total_token = total_service_time / @@token_icon
        else
          total_token = total_service_time / @@token_icon + 1
        end
      end
      logger.info("[info]: 合計の施術時間は#{total_service_time}分です。")
      logger.info("[info]: 合計金額は#{total_service_price}円です。")
      # ハッシュに格納した予約情報をコントローラでセッションにする
      appointment_service_hash[:service_names] = service_name
      appointment_service_hash[:total_service_time] = total_service_time
      appointment_service_hash[:total_token] = total_token
      appointment_service_hash[:total_service_price] = total_service_price
    end
    appointment_service_list.push(appointment_service_hash)
    appointment_service_list.push(noservice_flg)
    return appointment_service_list
  end

  # 予約スタッフ選択処理
  # apointment_staff_service_path
  def get_appointment_staff_list(staff_id)
    appointment_staff_list = []
    appointment_staff_hash = {}
    appointment_staff = nil
    nostaff_flg = 0
    # スタッフを選択せずに進んだ時の処理
    if staff_id.nil?
      @services = Service.all()
      logger.info("[info]: スタッフが選択されていません。")
      nostaff_flg = 1
    end

    if nostaff_flg == 0
      staff_info = Staff.find_by(id: staff_id)
      if staff_info.blank?
        appointment_staff = "指名なし"
      else
        appointment_staff = staff_info.displayname
      end
    end
    appointment_staff_hash[:staff_id] = staff_id
    appointment_staff_hash[:staff_name] = appointment_staff

    appointment_staff_list.push(appointment_staff_hash)
    appointment_staff_list.push(nostaff_flg)
    return appointment_staff_list
  end

  def get_appointment_calendar_hash
    available_hour_list = []
    available_min_list = [0, 30]
    display_time_list = []

    available_hour = @@business_open_hour
    while available_hour <= @@business_close_hour do
      available_hour_list.push(available_hour)
      available_hour += 1
    end

    str_min = nil
    str_hour = nil
    available_hour_list.each do |hour|
      i = 0
      str_hour = hour.to_s
      while i <= 1 do
        str_min = available_min_list[i].to_s
        if str_min == "0"
          str_min = "#{str_min}0"
        end
        display_time_list.push("#{str_hour}:#{str_min}")
        i += 1
      end
    end
    today = Date.today
    # この配列のインデックスは、date_idと同じ
    week_days_list = []
    j = 0
    while j <= 6 do
      week_day = Date.new(today.year, today.month, today.day + j)
      str_week_day = week_day.strftime("%m/%d(%a)")
      week_days_list.push(str_week_day)
      j += 1
    end
    # カレンダー用
    appointment_calendar_hash = {
      week_days: week_days_list,
      available_hour: available_hour_list,
      available_min: available_min_list,
      display_time: display_time_list
    }
    logger.info("[Debug]: #{appointment_calendar_hash}")
    return appointment_calendar_hash
  end

  # 予約カレンダー表示処理(スタッフの空き情報)
  def check_appointment(staff_id)
    reserved_appointment_list = []
    if staff_id == 0
      appointment = Appointment.all
    else
      appointments = Appointment.where(staffid: staff_id)
    end

    appointments.each do |appointment|
      logger.info("[Debug]: #{appointment.displaydate}")
      reserved_appointment_list.push(appointment)
    end
    return reserved_appointment_list
  end


  def get_appointment_time_hash(date_id, display_date, start_time, start_token_id, total_token, staff_id)
    appointment_time_hash= {}
    today = Date.today
    # 予約日を取得
    appointment_date = Date.new(today.year, today.month, today.day + date_id.to_i)
    # 予約トークン数取得
    int_start_token_id = start_token_id.to_i
    logger.info("[info]: スタートトークンID: #{int_start_token_id}")
    int_total_token = total_token.to_i
    end_token = int_start_token_id + int_total_token
    total_time = (end_token - int_start_token_id) * @@token_icon

    start_hour = start_time[0, 2].to_i
    start_min = start_time[3, 2].to_i
    end_hour = start_hour + (total_time / 60).floor
    end_min = (total_time % 60) * 60.floor
    # end_minが60分を越える時の処理
    if end_min >= 60
      end_hour += (end_min / 60).floor
      end_min = (end_min % 60) * 60.floor
    end

    logger.info("[info]: #{start_hour}時#{start_min}分")
    logger.info("[info]: #{end_hour}時#{end_min}分")
    logger.info("[info]: #{total_time}分")

    appointment_start_time = DateTime.new(today.year, today.month, today.day + date_id.to_i, start_hour, start_min)
    appointment_end_time = DateTime.new(today.year, today.month, today.day + date_id.to_i, end_hour, end_min)
    display_start_time = appointment_start_time.strftime("%Y年%m月%d日(%a) %H:%M〜")
    
    logger.info("[info]: 予約開始時間#{appointment_start_time}")
    logger.info("[info]: 予約終了時間#{appointment_end_time}")

    # 予約開始日時
    appointment_time_hash[:start_date] = appointment_start_time
    # 予約終了日時
    appointment_time_hash[:end_date] = appointment_end_time
    # 予約開始日付
    appointment_time_hash[:display_date] = display_date
    # 予約開始日時(表示用)
    appointment_time_hash[:display_start_date] = display_start_time
    # スタートトークンID
    appointment_time_hash[:start_token_id] = start_token_id
    # 合計サービス時間
    appointment_time_hash[:total_time] = total_time
    return appointment_time_hash
  end

  def get_appointment_customer_hash(firstname, lastname, email)
    appointment_customer_hash = {}
    appointment_customer_hash[:firstname] = firstname
    appointment_customer_hash[:lastname] = lastname
    appointment_customer_hash[:email] = email
    return appointment_customer_hash
  end

  # これで汎用的にセッション削除できるようにする
  # def delete_session()
  # end
end
