require "test_helper"

class SaleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sale_index_url
    assert_response :success
  end

  test "should get show" do
    get sale_show_url
    assert_response :success
  end

  test "should get new" do
    get sale_new_url
    assert_response :success
  end

  test "should get create" do
    get sale_create_url
    assert_response :success
  end

  test "should get cancel" do
    get sale_cancel_url
    assert_response :success
  end

  test "should get set_sale" do
    get sale_set_sale_url
    assert_response :success
  end
end
