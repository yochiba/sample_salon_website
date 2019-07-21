class Admin < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :adminid, presence: true
  validates :password, presence: true

  has_secure_password

  def login_checker(adminid, password)
    login_check_hash = {}
    admin_info = Admin.find_by(adminid: adminid)
    login_flg = 0
    if admin_info.present? && password.present? && admin_info.authenticate(password)
      flash_message = "パスワード認証に成功しました。"
      login_flg = 4
    elsif adminid.blank? && password.blank?
      login_flg = 1
      flash_message = "管理者IDとパスワードが空です。"
    elsif adminid.blank?
      login_flg = 2
      flash_message = "管理者IDが空です"
    elsif password.blank?
      login_flg = 3
      flash_message = "パスワードが空です。"
    else
      login_flg = 3
      flash_message = "管理者IDかパスワードが違います。"
    end
    login_check_hash[:login_flg] = login_flg
    login_check_hash[:flash_message] = flash_message
    
    return login_check_hash
  end

end
