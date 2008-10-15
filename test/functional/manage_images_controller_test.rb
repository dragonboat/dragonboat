require File.dirname(__FILE__) + '/../test_helper'
require 'manage_images_controller'

# Re-raise errors caught by the controller.
class ManageImagesController; def rescue_action(e) raise e end; end

class ManageImagesControllerTest < Test::Unit::TestCase
  def setup
    @controller = ManageImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
