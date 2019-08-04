require 'date'

class Appointment < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :servicename, presence: true
  validates :startdate, presence: true
  validates :starttime, presence: true
  validates :staffid, presence: true
  validates :staffname, presence: true
  validates :totalservicetime, presence: true
  validates :totalserviceprice, presence: true
  validates :totaltoken, presence: true
  validates :starttokenid, presence: true
  # validates :displaydate, presence: true

  # 始業時間
  @@BUSINESS_OPEN_HOUR = 10
  # 就業時間
  @@BUSINESS_CLOSE_HOUR = 19
  # 60分
  @@SIXTY_MINUTES = 60
  # トークン単位(30分/1トークン)
  @@TOKEN_ICON = 30
  # 一月の日数(30日分)
  @@MONTHLY_DATES = 30
  # 取得する月の数-1(0からスタート)
  @@MONTH_LIMIT = 3
  # 1月
  @@JANUARY = 1
  # 12月
  @@DECEMBER = 12
  # 1日
  @@FIRST_DAY = 1

  # 予約メニュー選択処理
  # appointment_service_path
  def get_appointment_service_array(service_name_array)
    appointment_service_array = []
    appointment_service_hash = {}
    noservice_flg = 0
    # サービスを選択せずに進んだ時の処理
    if service_name_array.nil?
      @services = Service.all()
      logger.info("[info]: サービスが選択されていません。")
      noservice_flg = 1
    end
    
    if noservice_flg == 0
      logger.info("[info]: 選択されたサービスは#{service_name_array}です。")
      # 施術トークン計算用(DBには格納しない)
      total_service_time = 0
      # 合計施術トークン数
      total_token = 0
      total_service_price = 0
      service_names = ""
      service_name_array.each_with_index do |service, i|
        logger.info("[info]: servicenameは、#{service}です。")
        # サービスの合計施術時間と合計金額を計算
        service_info = Service.find_by(servicename: service)
        # 予約確認画面等での表示フォーマット
        if i == service_name_array.length - 1
          service_names += "#{service_info.servicename}"
        else
          service_names += "#{service_info.servicename}, "
        end
        total_service_time += service_info.servicetime
        total_service_price += service_info.serviceprice
        # 予約時間トークン数を計算
        if total_service_time % @@TOKEN_ICON == 0
          total_token = total_service_time / @@TOKEN_ICON
        else
          total_token = total_service_time / @@TOKEN_ICON + 1
        end
      end
      logger.info("[info]: 合計の施術時間は#{total_service_time}分です。")
      logger.info("[info]: 合計金額は#{total_service_price}円です。")
      
      # ハッシュに格納した予約情報をコントローラでセッションにする
      appointment_service_hash[:service_names] = service_names
      appointment_service_hash[:total_service_time] = total_service_time
      appointment_service_hash[:total_token] = total_token
      appointment_service_hash[:total_service_price] = total_service_price
    end
    appointment_service_array.push(appointment_service_hash)
    appointment_service_array.push(noservice_flg)
    return appointment_service_array
  end

  # 予約スタッフ選択処理
  # apointment_staff_service_path
  def get_appointment_staff_array(staff_id)
    appointment_staff_array = []
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

    appointment_staff_array.push(appointment_staff_hash)
    appointment_staff_array.push(nostaff_flg)
    return appointment_staff_array
  end

  # カレンダーで使用する営業時間を生成取得する処理
  def get_business_hour_hash
    available_hour_array = []
    available_min_array = [0, 30]
    display_time_array = []

    # 始業~終業"hour"を配列に格納
    available_hour = @@BUSINESS_OPEN_HOUR
    while available_hour <= @@BUSINESS_CLOSE_HOUR do
      available_hour_array.push(available_hour)
      available_hour += 1
    end
    # 営業"時"と"分"を結合して配列に格納
    str_min = nil
    str_hour = nil
    available_hour_array.each do |hour|
      i = 0
      str_hour = hour.to_s
      while i <= 1 do
        str_min = available_min_array[i].to_s
        if str_min == "0"
          str_min = "#{str_min}0"
        end
        display_time_array.push("#{str_hour}:#{str_min}")
        i += 1
      end
    end
    # カレンダー用
    business_hour_hash = {
      available_hour: available_hour_array,
      available_min: available_min_array,
      display_time: display_time_array
    }
    logger.info("[Debug]: #{business_hour_hash}")
    return business_hour_hash
  end

  # カレンダーで使用する日付を生成取得する処理
  def generate_dates_hash
    # 当日の日付を取得
    today = Date.today
    # 日付情報および表示用日付の格納配列
    date_array = []
    display_date_array = []
    # 来月が新年ならフラグON
    new_year_flg = false
    # +1月でmonth_counter += 1
    month_counter = 0
    while month_counter <= @@MONTH_LIMIT
      # 日付カウント
      date_counter = 0
      # 新年になった場合の月カウント
      new_year_month_counter = 0
      while date_counter <= @@MONTHLY_DATES do
        year = 0
        month = 0
        date = 0
        if new_year_flg
          year = today.year + 1
          month = @@JANUARY + new_year_month_counter
          date = @@FIRST_DAY + date_counter
        elsif !new_year_flg && month_counter == 0
          year = today.year
          month = today.month
          date = today.day + date_counter
        elsif !new_year_flg
          year = today.year
          month = today.month + month_counter
          date = @@FIRST_DAY + date_counter
        end
        month_date = Date.new(year, month, date)
        month_end = Date.new(year, month, -1)
        # 日付情報および、表示用日付情報を配列に格納
        str_date = month_date.strftime("%m/%d(%a)")
        date_array.push(month_date)
        display_date_array.push(str_date)
        # 年を跨ぐ場合        
        if month_date.day == month_end.day && month_date.month == @@DECEMBER
          new_year_flg = true
          date_counter = 0
          break
        elsif month_date.day == month_end.day && month_date.month != @@DECEMBER
          date_counter = 0
          if new_year_flg
            new_year_month_counter += 1
          end
          break
        end
        date_counter += 1
      end
      month_counter += 1
    end
    dates_hash = {
      display_date: display_date_array,
      date: date_array
    }
    return dates_hash
  end

  # スタッフの空き情報をカレンダーに反映する処理
  def check_existing_appointment(staff_id)
    reserved_appointment_hash = {}
    existing_appointments_array = []
    if staff_id == 0
      existing_appointments_array = Appointment.where(past_flg: staff_id)
    else
      existing_appointments_array = Appointment.where(staffid: staff_id, past_flg: 0)
    end
    return existing_appointments_array
  end

  # スタッフ選択時の各予約における予約済トークン計算処理(合計トークンとの比較は行わない)
  def get_daily_tokens_flg_hash(dates_hash, existing_appointments_array, business_hour_array, total_token)
    # key:日付, value:トークンID順のトークンフラグ(0 or 1)
    daily_tokens_flg_hash = {}
    # 4ヶ月分の日付配列を回す
    dates_hash[:date].each do |date|
      token_flg_array = []
      i = 0
      while i < business_hour_array.length do
        end_index = business_hour_array.length - total_token + 1
        if i >= end_index || date.wday == 2
        # if date.wday == 2
          token_flg_array.push(1)
        else
          token_flg_array.push(0)
        end
        i += 1
      end
      # daily_tokens_flg_hash.store(date.to_s, token_flg_array)
      # FIXME これによって、一日の締めがおかしくなっている。
      existing_appointments_array.each do |appointment|
        if date == appointment.startdate
          logger.info("[info]::::appointment check IN")
          start_token_id = appointment.starttokenid
          # 新規予約の最後のトークンID
          end_token_id = start_token_id + appointment.totaltoken - 1
          while start_token_id <= end_token_id do
            token_flg_array[start_token_id] = 1
            start_token_id += 1
          end
        end
      end
      daily_tokens_flg_hash.store(date.to_s, token_flg_array)
      logger.info("[info]::::appointment check #{date} #{token_flg_array}")
    end
    return daily_tokens_flg_hash
  end

  # 予約済み範囲の最終的な結果を取得
  # (各予約間のトークン数と新規予約の合計トークン数を比較して、予約の可否を算出)
  def get_final_tokens_flg_hash(daily_tokens_flg_hash, total_token)
    # key:予約日, value:トークンID順のトークンフラグ(0 or 1)
    reserved_appointment_hash = daily_tokens_flg_hash
    # 連続する予約なしのトークンフラグをカウント
    unreserved_token_counter = 0
    daily_tokens_flg_hash.each do |date, token_array|
      i = 0
      # daily_token_flg_array = []
      while  i < token_array.length do
        # logger.info("[info]::::array check #{date} #{token_array}")
        if token_array[i] == 1
          # daily_token_flg_array.push(1)
          logger.info("[info]::::array check IN")
          if unreserved_token_counter < total_token
            token = i - unreserved_token_counter
            token_end = i - 1
            while token <= token_end
              # daily_token_flg_array[token] = 1
              reserved_appointment_hash["#{date.to_s}"][token] = 1
              token += 1
            end
          end
          unreserved_token_counter = 0
        else
          # daily_token_flg_array.push(token_array[i])
          unreserved_token_counter += 1
        end
        i += 1
      end
      # reserved_appointment_hash.store(date, daily_token_flg_array)
      unreserved_token_counter = 0
    end
    return reserved_appointment_hash
  end

  # 予約日時を計算および構築する処理
  def get_appointment_time_hash(date_counter, date, start_time, start_token_id, total_token, staff_id)
    # 予約日を取得
    appointment_start_date = date.to_date
    # 予約トークン数取得処理
    int_start_token_id = start_token_id.to_i
    int_total_token = total_token.to_i
    end_token = int_start_token_id + int_total_token
    total_time = (end_token - int_start_token_id) * @@TOKEN_ICON
    # 予約開始時間(時)
    start_hour = start_time[0, 2].to_i
    # 予約開始時間(分)
    start_min = start_time[3, 2].to_i
    # 予約終了時間(時)
    end_hour = start_hour + (total_time / @@SIXTY_MINUTES).floor
    # 予約終了時間(分)
    end_min = (total_time % @@SIXTY_MINUTES) * @@SIXTY_MINUTES.floor
    # end_minが60分を越える時の処理
    if end_min >= @@SIXTY_MINUTES
      end_hour += (end_min / @@SIXTY_MINUTES).floor
      end_min = (end_min % @@SIXTY_MINUTES) * @@SIXTY_MINUTES.floor
    end

    logger.info("[info]: スタートトークンID: #{int_start_token_id}")
    logger.info("[info]: #{start_hour}時#{start_min}分")
    logger.info("[info]: #{end_hour}時#{end_min}分")
    logger.info("[info]: #{total_time}分")

    appointment_start_time = Time.new(appointment_start_date.year, appointment_start_date.month, appointment_start_date.day, start_hour, start_min)
    display_start_date = appointment_start_date.strftime("%Y年%m月%d日(%a)")
    display_start_time = appointment_start_time.strftime("%H:%M〜")
    
    logger.info("[info]: 予約開始日#{appointment_start_date}")
    logger.info("[info]: 予約開始時間#{appointment_start_time}")

    appointment_time_hash= {}
    # 予約開始日
    appointment_time_hash[:start_date] = appointment_start_date
    # 予約開始時間
    appointment_time_hash[:start_time] = appointment_start_time
    # 予約開始日付
    appointment_time_hash[:display_date] = appointment_start_date.strftime("%m月%d日(%a)")
    # 予約開始日(表示用)
    appointment_time_hash[:display_start_date] = display_start_date
    # 予約開始時(表示用)
    appointment_time_hash[:display_start_time] = display_start_time
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
