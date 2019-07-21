require 'test_helper'

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get appointment_service" do
    get appointments_appointment_service_url
    assert_response :success
  end

  test "should get appointment_staff" do
    get appointments_appointment_staff_url
    assert_response :success
  end

  test "should get appointment_date" do
    get appointments_appointment_date_url
    assert_response :success
  end

  test "should get appointment_confirmation" do
    get appointments_appointment_confirmation_url
    assert_response :success
  end

  test "should get appointment_complete" do
    get appointments_appointment_complete_url
    assert_response :success
  end

end
