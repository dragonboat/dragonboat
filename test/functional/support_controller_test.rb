require File.dirname(__FILE__) + '/../test_helper'
require 'support_controller'

# Re-raise errors caught by the controller.
class SupportController; def rescue_action(e) raise e end; end

class SupportControllerTest < Test::Unit::TestCase
  def setup
    @controller = SupportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
