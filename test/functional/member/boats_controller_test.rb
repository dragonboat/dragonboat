require File.dirname(__FILE__) + '/../../test_helper'
require 'member/boats_controller'

# Re-raise errors caught by the controller.
class Member::BoatsController; def rescue_action(e) raise e end; end

class Member::BoatsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Member::BoatsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
