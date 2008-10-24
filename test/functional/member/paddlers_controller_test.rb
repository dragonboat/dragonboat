require File.dirname(__FILE__) + '/../../test_helper'
require 'member/paddlers_controller'

# Re-raise errors caught by the controller.
class Member::PaddlersController; def rescue_action(e) raise e end; end

class Member::PaddlersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Member::PaddlersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
