require 'date'

class Staff < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :staffid, presence: true
  validates :displayname, presence: true

  has_secure_password

  # trueならアカウント情報, falseならエラーメッセージを返す
  def get_staff_info_hash(lastname, firstname, staff_id, display_name, email, password, password_confirmation)
    error_message = registration_form_checker(lastname, firstname, staff_id, display_name, email, password, password_confirmation)
    staff_info_hash = {}
    if error_message.present?
      staff_info_hash.store("error_message", error_message)
    else
      staff_info_hash.store("lastname", lastname)
      staff_info_hash.store("firstname", firstname)
      staff_info_hash.store("staff_id", staff_id)
      staff_info_hash.store("display_name", display_name)
      staff_info_hash.store("email", email)
      staff_info_hash.store("password", password)
      staff_info_hash.store("password_confirmation", password_confirmation)
    end
    return staff_info_hash
  end

  def staff_registrator(staff_info_hash)
    staff_info = Staff.new(
      firstname: staff_info_hash["firstname"],
      lastname: staff_info_hash["lastname"],
      staffid: staff_info_hash["staff_id"],
      displayname: staff_info_hash["display_name"],
      email: staff_info_hash["email"],
      password: staff_info_hash["password"],
      password_confirmation: staff_info_hash["password_confirmation"]
    )
    if staff_info.valid?
      staff_info.save!
      logger.debug("[info]: スタッフ登録に成功しました。")
      return true
    else
      logger.debug("[info]: スタッフ登録に失敗しました。")
      return false
    end
  end

  # ログイン確認(login_service)
  def login_checker(staff_id, password)
    login_check_hash = {}
    flash_message = nil
    staff_info = Staff.find_by(staffid: staff_id)
    login_flg = 0
    if staff_info.present? && password.present? && staff_info.authenticate(password)
      flash_message = "ログインに成功しました。"
    elsif staff_id.blank? && password.blank?
      login_flg = 1
      flash_message = "スタッフIDとパスワードが空です。"
    elsif staff_id.blank?
      login_flg = 2
      flash_message = "スタッフIDが空です"
    elsif password.blank?
      login_flg = 3
      flash_message = "パスワードが空です。"
    else
      login_flg = 4
      flash_message = "スタッフIDかパスワードが違います。"
    end
    login_check_hash.store("login_flg", login_flg)
    login_check_hash.store("flash_message", flash_message)
    return login_check_hash
  end

  # スタッフ スケジュール管理ページ カレンダー用
  def check_schedule(staff_id)
    today = Date.today
    current_month_end = Date.new(today.year, today.month, -1)
    monthly_dates_hash = {}
    staff_id_number = Staff.find_by(staffid: staff_id)
    appointments_array = Appointment.where(staffid: staff_id_number)
    i = 1
    while i <= current_month_end.day do
      daily_appointments_array = []
      monthly_date = Date.new(today.year, today.month, i)
      display_date = monthly_date.strftime("%m/%d(%a)")
      if appointments_array.present?
        appointments_array.each do |appointment|
          if appointment.startdate == monthly_date
            logger.info("[info]:該当する予約が見つかりました")
            daily_appointments_array.push(appointment)
          end
        end
      end
      monthly_dates_hash.store(monthly_date, daily_appointments_array)
      i += 1
    end
    return monthly_dates_hash
  end

  private
  def registration_form_checker(lastname, firstname, staff_id, display_name, email, password, password_confirmation)
    error_message = ""
    error_message_array = []
    if lastname.blank?
      error_message_array.push("苗字")
    end

    if firstname.blank?
      error_message_array.push("名前")
    end

    if staff_id.blank?
      error_message_array.push("スタッフID")
    end
    
    if display_name.blank?
      error_message_array.push("表示名")
    end

    if email.blank?
      error_message_array.push("Email")
    end

    if password.blank? && password_confirmation
      error_message_array.push("パスワード")
    elsif password_confirmation.blank?
      error_message_array.push("確認用パスワード")
    end

    if error_message_array.present?
      error_message_array.each_with_index do |message, index|
        if index == error_message_array.length - 1
          error_message += "#{message}が入力されていません。"
        else
          error_message += "#{message}, "
        end
      end
    end
    return error_message
  end

end
