class Customer < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :userid, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  
  has_secure_password

  # ユーザー登録フォーム情報確認
  def get_customer_info_hash(lastname, firstname, age, gender, user_id, email, password, password_confirmation)
    error_message = registration_form_checker(lastname, firstname, age, gender, user_id, email, password, password_confirmation)
    customer_info_hash = {}
    if error_message.present?
      customer_info_hash.store("error_message", error_message)
    else
      customer_info_hash.store("lastname", lastname)
      customer_info_hash.store("firstname", firstname)
      customer_info_hash.store("age", age)
      customer_info_hash.store("gender", gender)
      customer_info_hash.store("staff_id", user_id)
      customer_info_hash.store("email", email)
      customer_info_hash.store("password", password)
      customer_info_hash.store("password_confirmation", password_confirmation)
    end
    return customer_info_hash
  end

  # TODO パスワードと確認用パスワードが一致しない場合のflash処理を追加
  def customer_registrator(customer_info_hash)
    customer_info = Customer.new(
      firstname: customer_info_hash["firstname"],
      lastname: customer_info_hash["lastname"],
      userid: customer_info_hash["user_id"],
      age: customer_info_hash["age"],
      gender: customer_info_hash["gender"],
      email: customer_info_hash["email"],
      password: customer_info_hash["password"],
      password_confirmation: customer_info_hash["password_confirmation"]
    )
    if customer_info.valid?
      customer_info.save!
      logger.debug("[info]: ユーザー登録に成功しました。")
      return true
    else
      logger.debug("[info]: ユーザー登録に失敗しました。")
      return false
    end
  end

  # ログイン確認(login_service)
  def login_checker(user_id, password)
    login_check_hash = {}
    flash_message = nil
    customer_info = Customer.find_by(userid: user_id)
    login_flg = 0
    if customer_info.present? && password.present? && customer_info.authenticate(password)
      flash_message = "ログインに成功しました。"
    elsif user_id.blank? && password.blank?
      login_flg = 1
      flash_message = "ユーザーIDとパスワードが空です。"
    elsif user_id.blank?
      login_flg = 2
      flash_message = "ユーザーIDが空です"
    elsif password.blank?
      login_flg = 3
      flash_message = "パスワードが空です。"
    else
      login_flg = 4
      flash_message = "ユーザーIDかパスワードが違います。"
    end
    login_check_hash.store("login_flg", login_flg)
    login_check_hash.store("flash_message", flash_message)
    return login_check_hash
  end

  # ユーザーアカウント情報取得処理
  def get_user_account(user_id)
    customer_info = Customer.find_by(userid: user_id)
    return customer_info
  end

  # ユーザーアカウント内で新規の予約情報を取得する
  def get_appointment_info(firstname, lastname, email)
    appointment_info = Appointment.where(
      firstname: firstname,
      lastname: lastname,
      email: email,
      past_flg: 0
    )
    return appointment_info
  end

  # ユーザーアカウント内で過去の予約情報を取得する
  def get_past_appointment_info(firstname, lastname, email)
    past_appointment_array = Appointment.where( 
      firstname: firstname,
      lastname: lastname,
      email: email,
      past_flg: 1
      ).order(startdate: :DESC).limit 3
    
    if past_appointment_array.present?
      return past_appointment_array
    else
      message = "過去の予約はございません。"
      return message
    end
  end

  private
  def registration_form_checker(lastname, firstname, user_id, age, gender, email, password, password_confirmation)
    error_message = ""
    error_message_array = []
    if lastname.blank?
      error_message_array.push("苗字")
    end

    if firstname.blank?
      error_message_array.push("名前")
    end

    if user_id.blank?
      error_message_array.push("ユーザーID")
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