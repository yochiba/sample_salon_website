class ServicesController < ApplicationController
  before_action :direct_login_checker, {only: [
    :service_manage,
    :service_add,
    :service_add_service,
    :service_edit,
    :service_delete
  ]}

  def service_manage
    @admin_info = Admin.find_by(adminid: session[:admin_id])
    @services = Service.all
  end

  def service_manage_service
    # FIXME ransackを使った検索に変更する
    @admin_info = Admin.find_by(adminid: session[:admin_id])
    # @q = Service.ransack(params[:q])
    # @service_info = @q.result(distinct: true).recent
    service_info = Service.where("servicekeyword LIKE ?", "%#{params[:keyword]}%")
    if service_info.present?
      # TODO 検索結果件数の表示
      flash[:search_result] = "検索結果"
      service_name_list = []
      service_info.each do |service|
        service_name_list.push("#{service.servicename}")
        logger.debug("[debug]: #{service.servicename}")
      end
      session[:service] = service_name_list
      redirect_to "/service_manage"
    else
      flash.now[:search_result] = "検索結果が見つかりませんでした"
      render "/services/service_manage"
    end
  end

  def service_add
    services = Service.new
    @service_category_list = services.get_service_categories
  end

  def service_add_service
    service_info = Service.new(
      servicename: params[:service_name],
      servicecategory: params[:service_category],
      servicetime: params[:service_time],
      serviceprice: params[:service_price],
      servicekeyword: params[:service_keyword],
      description: params[:service_description]
    )

    if params[:service_image].present?
      image_file = params[:service_image]
      image_name = "#{params[:service_name]}.jpg"
      service_info.serviceimage = "#{image_name}"
      File.binwrite("public/service_images/#{image_name}", image_file.read)
    end

    if service_info.valid?
      service_info.save!
      flash[:notice] = "サービスを追加しました。"
      logger.info("[info]: サービス追加に成功しました。")
      redirect_to service_add_path
    else
      flash.now[:notice] = "サービス追加に失敗しました。"
      logger.info("[info]: サービス追加に失敗しました。")
      render "services/service_add/"
    end
  end

  def service_edit
    @service_info = Service.find_by(servicename: params[:service_name])
  end

  def service_edit_service

  end

  def service_delete
    @service_info = Service.find_by(servicename: params[:service_name])
  end

  def service_delete_service
    logger.info("[info]:#{params[:servicename]}")
    service_info = Service.find_by(servicename: params[:service_name])
    logger.info("[info]:#{service_info.servicename}")
    
    if service_info.valid?
      service_info.destroy!
      logger.info("[info]: サービスを削除に成功しました。")
      flash[:notice] = "サービスを削除しました。"
      redirect_to service_manage_path
    else
      logger.info("[info]: サービスを削除に失敗しました。")
      flash.now[:notice] = "サービスを削除できませんでした。"
      redirect_to service_edit_path(service_info.servicename)
    end
  end

  def service_detail
    @service_info = Service.find_by(servicename: params[:service_name])
  end

  def service_category
    @service_category_name = Service.find_by(servicecategory: params[:service_category])
    @service_category = Service.where(servicecategory: params[:service_category])
  end

  private
  def direct_login_checker
    if session[:admin_id].blank?
      flash[:notice] = "ログインしてください。"
      redirect_to admin_login_path
    end
  end
end
