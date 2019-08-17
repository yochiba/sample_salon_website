class Staff < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :displayname, presence: true

  def get_staff_info_hash(lastname, firstname, display_name, email)
    staff_info_hash = {
      lastname: lastname,
      firstname: firstname,
      display_name: display_name,
      email: email
    }
    return staff_info_hash
  end

  def staff_add_form_checker(lastname, firstname, display_name, email)
    # FIXME 今のままでは、複数の空欄があった場合に全て最初にマッチしたエラーになってしまう
    staff_add_error_message = nil
    if lastname.blank?
      staff_add_error_message = "苗字が入力されていません。"
    elsif firstname.blank?
      staff_add_error_message = "名前が入力されていません。"
    elsif display_name.blank?
      staff_add_error_message = "表示名が入力されていません。"
    elsif email.blank?
      staff_add_error_message = "Emailが入力されていません。"
    end
    return staff_add_error_message
  end

  def staff_registrator(staff_info_hash)
    staff_info = Staff.new(
      firstname: staff_info_hash["firstname"],
      lastname: staff_info_hash["lastname"],
      displayname: staff_info_hash["display_name"],
      email: staff_info_hash["email"]
    )
    if staff_info.valid?
      staff_info.save!
      logger.debug("[info]: スタッフ登録に成功しました。")
    else
      logger.debug("[info]: スタッフ登録に失敗しました。")
    end
  end
end
