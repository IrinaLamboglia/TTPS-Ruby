require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:one)
    @image.file.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test_image.png')), filename: 'test_image.png', content_type: 'image/png')
  end

  test "should get index" do
    get images_url
    assert_response :success
  end

  test "should create image" do
    assert_difference('Image.count') do
      post images_url, params: { image: { file: fixture_file_upload('files/test_image.png', 'image/png'), product_id: 1 } }
    end
    assert_redirected_to image_url(Image.last)
  end

  test "should show image" do
    get image_url(@image)
    assert_response :success
  end

  test "should destroy image" do
    assert_difference('Image.count', -1) do
      delete image_url(@image)
    end
    assert_redirected_to images_url
  end
end