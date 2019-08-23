require 'test_helper'

class StaffsControllerTest < ActionDispatch::IntegrationTest
  test "should get staff_account" do
    get staffs_staff_account_url
    assert_response :success
  end

  test "should get staff_login" do
    get staffs_staff_login_url
    assert_response :success
  end

end
