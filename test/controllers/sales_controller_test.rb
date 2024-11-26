require "test_helper"

class SalesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sales_index_url
    assert_response :success
  end

  test "should get new" do
    get sales_new_url
    assert_response :success
  end

  test "should get create" do
    get sales_create_url
    assert_response :success
  end

  test "should get sale_params" do
    get sales_sale_params_url
    assert_response :success
  end

  test "should get update_stock" do
    get sales_update_stock_url
    assert_response :success
  end
end
