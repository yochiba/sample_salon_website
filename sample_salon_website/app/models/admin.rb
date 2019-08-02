class Admin < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :adminid, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password

  def login_checker(admin_id, password)
    login_check_hash = {}
    admin_info = Admin.find_by(adminid: admin_id)
    login_flg = 0
    if admin_info.present? && password.present? && admin_info.authenticate(password)
      flash_message = "パスワード認証に成功しました。"
      login_flg = 4
    elsif admin_id.blank? && password.blank?
      login_flg = 1
      flash_message = "管理者IDとパスワードが空です。"
    elsif admin_id.blank?
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

  def admin_edit_handler(lastname, firstname, email, admin_id)
    admin_edit_hash = {}
    admin_info = Admin.find_by(adminid: admin_id)
    if lastname.present? && lastname != admin_info.lastname
      admin_edit_hash[:edited_lastname] = lastname
    end

    if firstname.present? && lastname != admin_info.firstname
      admin_edit_hash[:edited_firstname] = firstname
    end

    if email.present? && email != admin_info.email
      admin_edit_hash[:edited_email] = email
    end

    if admin_id.present? && admin_id != admin_info.admin_id
      admin_edit_hash[:edited_admin_id] = admin_id
    end
    return admin_edit_hash
    # パスワード編集処理
    # if edited_password.present? && edited_lastname != admin_info.lastname
    # end
  end
end
