require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/boat_types_controller'

# Re-raise errors caught by the controller.
class Admin::BoatTypesController; def rescue_action(e) raise e end; end

class Admin::BoatTypesControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::BoatTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
