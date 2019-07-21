require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get admin_login" do
    get admins_admin_login_url
    assert_response :success
  end

  test "should get admin_manage" do
    get admins_admin_manage_url
    assert_response :success
  end

  test "should get admin_add" do
    get admins_admin_add_url
    assert_response :success
  end

  test "should get admin_edit" do
    get admins_admin_edit_url
    assert_response :success
  end

  test "should get admin_delete" do
    get admins_admin_delete_url
    assert_response :success
  end

end
