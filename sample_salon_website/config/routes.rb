Rails.application.routes.draw do
  # main controller
  get '', to: 'main#home', as: 'home'
  get '/about', to: 'main#about', as: 'about'
  get '/services', to: 'main#services', as: 'services'
  get '/contact', to: 'main#contact', as: 'contact'
  post '/contact', to: 'main#contact_service', as: 'contact_service'
  get '/account', to: 'main#account', as: 'account'
  get '/login', to: 'main#login', as: 'login'
  post '/login', to: 'main#login_service', as: 'login_service'
  post '/logout', to: 'main#logout_service', as: 'logout_service'
  get '/registration', to: 'main#registration', as: 'registration'
  post '/registration', to: 'main#registration_service', as: 'registration_service'
  get '/registration_confirmation', to: 'main#registration_confirmation', as: 'registration_confirmation'
  post '/registration_confirmation/:flg', to: 'main#registration_confirmation_service', as: 'registration_confirmation_service'

  # admins controller
  get '/admin_login', to: 'admins#admin_login', as: 'admin_login'
  post '/admin_login', to: 'admins#admin_login_service', as: 'admin_login_service'
  get '/admin_account', to: 'admins#admin_account', as: 'admin_account'
  get '/admin_manage', to: 'admins#admin_manage', as: 'admin_manage'
  get '/admin_add', to: 'admins#admin_add', as: 'admin_add'
  post '/admin_add', to: 'admins#admin_add_service', as: 'admin_add_service'
  get '/admin_edit/:admin_id', to: 'admins#admin_edit', as: 'admin_edit'
  post '/admin_edit/:admin_id', to: 'admins#admin_edit_service', as: 'admin_edit_service'
  get '/admin_edit_confirmation/:admin_id', to: 'admins#admin_edit_confirmation', as: 'admin_edit_confirmation'
  put '/admin_edit_confirmation/:admin_id', to: 'admins#admin_edit_confirmation_service', as: 'admin_edit_confirmation_service'
  get '/admin_delete/:admin_id', to: 'admins#admin_delete', as: 'admin_delete'
  post '/admin_delete/:admin_id', to: 'admins#admin_delete_service', as: 'admin_delete_service'
  get '/admin_manage_appointment', to: 'admins#admin_manage_appointment', as: 'admin_manage_appointment'
  post '/admin_manage_appointment/:appointment_id', to: 'admins#admin_manage_appointment_service', as: 'admin_manage_appointment_service'
  get '/admin_manage_contact', to: 'admins#admin_manage_contact', as: 'admin_manage_contact'
  get '/admin_manage_staff', to: 'admins#admin_manage_staff', as: 'admin_manage_staff'
  get '/admin_manage_staff_shift/:staff_id', to: 'admins#admin_manage_staff_shift', as: 'admin_manage_staff_shift'
  get '/admin_manage_staff_add', to: 'admins#admin_manage_staff_add', as: 'admin_manage_staff_add'
  post '/admin_manage_staff_add', to: 'admins#admin_manage_staff_add_service', as: 'admin_manage_staff_add_service'
  get '/admin_manage_staff_add_confirmation', to: 'admins#admin_manage_staff_add_confirmation', as: 'admin_manage_staff_add_confirmation'
  post '/admin_manage_staff_add_confirmation/:flg', to: 'admins#admin_manage_staff_add_confirmation_service', as: 'admin_manage_staff_add_confirmation_service'
  post '/admin_logout', to: 'admins#admin_logout_service', as: 'admin_logout_service'

  # staffs controller
  get '/staff_account', to: 'staffs#staff_account', as: 'staff_account'
  get '/staff_login', to: 'staffs#staff_login', as: 'staff_login'
  post '/staff_login', to: 'staffs#staff_login_service', as: 'staff_login_service'
  post '/staff_logout', to: 'staffs#staff_logout_service', as: 'staff_logout_service'
  get '/staff_shift', to: 'staffs#staff_shift', as: 'staff_shift'
  get '/staff_vacation/:date', to: 'staffs#staff_vacation', as: 'staff_vacation'

  # services controller
  get '/service_manage', to: 'services#service_manage', as: 'service_manage'
  post '/service_manage', to: 'services#service_manage_service', as: 'service_manage_service'
  get '/service_add', to: 'services#service_add', as: 'service_add'
  post 'service_add', to: 'services#service_add_service', as: 'service_add_service'
  get '/service_edit/:service_name', to: 'services#service_edit', as: 'service_edit'
  post '/service_edit/:service_name', to: 'services#service_edit_service', as: 'service_edit_service'
  get '/service_delete/:service_name', to: 'services#service_delete', as: 'service_delete'
  post '/service_delete/:service_name', to: 'services#service_delete_service', as: 'service_delete_service'
  get '/service_detail/:service_name', to: 'services#service_detail', as: 'service_detail'
  get '/service_category/:service_category', to: 'services#service_category', as: 'service_category'

  # appointment controller
  get '/appointment', to: 'appointments#appointment', as: 'appointment'
  post '/appointment', to: 'appointments#appointment_service', as: 'appointment_service'
  get '/appointment_staff', to: 'appointments#appointment_staff', as: 'appointment_staff'
  post '/appointment_staff/:staff_id', to: 'appointments#appointment_staff_service', as: 'appointment_staff_service'
  get '/appointment_date', to: 'appointments#appointment_date', as: 'appointment_date'
  post '/appointment_date/:date_counter/:date/:start_time/:start_token_id', to: 'appointments#appointment_date_service', as: 'appointment_date_service'
  get '/appointment_customer_info', to: 'appointments#appointment_customer_info', as: 'appointment_customer_info'
  post '/appointment_customer_info', to: 'appointments#appointment_customer_info_service', as: 'appointment_customer_info_service'
  get '/appointment_confirmation', to: 'appointments#appointment_confirmation', as: 'appointment_confirmation'
  post '/appointment_confirmation', to: 'appointments#appointment_confirmation_service', as: 'appointment_confirmation_service'
  post '/appointment_delete', to: 'appointments#appointment_delete_service', as: 'appointment_delete_service'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
