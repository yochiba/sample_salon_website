require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get main_home_url
    assert_response :success
  end

  test "should get about" do
    get main_about_url
    assert_response :success
  end

  test "should get services" do
    get main_services_url
    assert_response :success
  end

  test "should get contact" do
    get main_contact_url
    assert_response :success
  end

  test "should get service" do
    get main_service_url
    assert_response :success
  end

  test "should get appointment" do
    get main_appointment_url
    assert_response :success
  end

  test "should get account" do
    get main_account_url
    assert_response :success
  end

  test "should get login" do
    get main_login_url
    assert_response :success
  end

end
