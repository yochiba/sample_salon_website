class Customer < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :userid, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  
  has_secure_password

  # ユーザー登録(registration_service)
  # TODO パスワードと確認用パスワードが一致しない場合のflash処理を追加
  def customer_registration?(firstname, lastname, age, gender, email, user_id, password, password_confirmation)
    customer_info = Customer.new(
      firstname: firstname,
      lastname: lastname,
      age: age,
      gender: gender,
      email: email,
      userid: user_id,
      password: password,
      password_confirmation: password_confirmation
      )
    if customer_info.valid?
      customer_info.save!
      return true
    else
      return false
    end
  end

  # ログイン確認(login_service)
  def login_checker(user_id, password)
    login_check_hash = {}
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
    login_check_hash[:login_flg] = login_flg
    login_check_hash[:flash_message] = flash_message
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
end