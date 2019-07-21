require 'test_helper'

class ServicesControllerTest < ActionDispatch::IntegrationTest
  test "should get service_show" do
    get services_service_show_url
    assert_response :success
  end

  test "should get service_add" do
    get services_service_add_url
    assert_response :success
  end

  test "should get service_edit" do
    get services_service_edit_url
    assert_response :success
  end

  test "should get service_delete" do
    get services_service_delete_url
    assert_response :success
  end

end
