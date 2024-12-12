require "test_helper"

class SalesControllerTest < ActionDispatch::IntegrationTest


  setup do
    @sale = sales(:one)
    @employee = users(:employee)
    @customer = users(:customer)
    @product = products(:one)
  end

  test "should get index" do
    get sales_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_url
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count', 1) do
      assert_difference('@product.reload.stock', -1) do
        post sales_url, params: {
          sale: {
            employee_id: @employee.id,
            customer_id: @customer.id,
            total: @product.price,
            date: DateTime.now,
            sale_items_attributes: [
              {
                product_id: @product.id,
                quantity: 1, # Ajusta la cantidad según el caso
                price: @product.price
              }
            ]
          }
        }
      end
    end
  end
  
  

  test "should show sale" do
    get sale_url(@sale)
    assert_response :success
  end


end
