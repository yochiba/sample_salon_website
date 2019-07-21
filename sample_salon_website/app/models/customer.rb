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
  def customer_registration?(firstname, lastname, age, gender, email, userid, password, password_confirmation)
    customer_info = Customer.new(
      firstname: firstname,
      lastname: lastname,
      age: age,
      gender: gender,
      email: email,
      userid: userid,
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
  def login_checker(userid, password)
    login_check_hash = {}
    customer_info = Customer.find_by(userid: userid)
 
    login_flg = 0
    if customer_info.present? && password.present? && customer_info.authenticate(password)
      flash_message = "パスワード認証に成功しました。"
      login_flg = 5
    elsif userid.blank? && password.blank?
      login_flg = 1
      flash_message = "ユーザーIDとパスワードが空です。"
    elsif userid.blank?
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
end
