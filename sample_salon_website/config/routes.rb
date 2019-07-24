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
  put '/admin_edit/:admin_id', to: 'admins#admin_edit_service', as: 'admin_edit_service'
  get '/admin_edit_confirmation/:admin_id', to: 'admins#admin_edit_confirmation', as: 'admin_edit_confirmation'
  put '/admin_edit_confirmation/:admin_id', to: 'admins#admin_edit_confirmation_service', as: 'admin_edit_confirmation_service'
  get '/admin_delete/:admin_id', to: 'admins#admin_delete', as: 'admin_delete'
  post '/admin_delete/:admin_id', to: 'admins#admin_delete_service', as: 'admin_delete_service'
  get '/admin_manage_appointment', to: 'admins#admin_manage_appointment', as: 'admin_manage_appointment'
  get '/admin_manage_contact', to: 'admins#admin_manage_contact', as: 'admin_manage_contact'
  post '/admin_logout', to: 'admins#admin_logout_service', as: 'admin_logout_service'

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

  # appointment controller
  get '/appointment', to: 'appointments#appointment', as: 'appointment'
  post '/appointment', to: 'appointments#appointment_service', as: 'appointment_service'
  get '/appointment_staff', to: 'appointments#appointment_staff', as: 'appointment_staff'
  post '/appointment_staff', to: 'appointments#appointment_staff_service', as: 'appointment_staff_service'
  get '/appointment_date', to: 'appointments#appointment_date', as: 'appointment_date'
  post '/appointment_date/:date_id/:date/:start_time/:start_token_id', to: 'appointments#appointment_date_service', as: 'appointment_date_service'
  get '/appointment_customer_info', to: 'appointments#appointment_customer_info', as: 'appointment_customer_info'
  post '/appointment_customer_info', to: 'appointments#appointment_customer_info_service', as: 'appointment_customer_info_service'
  get '/appointment_confirmation', to: 'appointments#appointment_confirmation', as: 'appointment_confirmation'
  post '/appointment_confirmation', to: 'appointments#appointment_confirmation_service', as: 'appointment_confirmation_service'
  get '/appointment_complete', to: 'appointments#appointment_complete', as: 'appointment_complete'
  post '/appointment_delete', to: 'appointments#appointment_delete_service', as: 'appointment_delete_service'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/test', to: 'main#test', as: 'test'
  post '/test/:date_id/:youbi_id/:week_id', to: 'main#test_service', as: 'test_service'
  get '/test_2/:date_id/:youbi_id/:week_id', to: 'main#test_2', as: 'test_2'

end
