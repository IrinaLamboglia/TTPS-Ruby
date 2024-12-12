require "test_helper"

class Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_products_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_product_url
    assert_response :success
  end



  test "should get edit" do
    get edit_admin_product_url(products(:one))  # Usa el helper de rutas para 'edit' dentro del namespace admin
    assert_response :success
  end

  test "should get update" do
    patch admin_product_url(products(:one)), params: { product: { name: "Updated Product" } }
    assert_response :success
  end


  test "should get destroy" do
    delete admin_product_url(products(:one))  # Usa el helper de rutas para 'destroy'
    assert_response :redirect
  end
end
