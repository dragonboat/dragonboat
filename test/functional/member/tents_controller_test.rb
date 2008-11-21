require File.dirname(__FILE__) + '/../../test_helper'
require 'member/tents_controller'

# Re-raise errors caught by the controller.
class Member::TentsController; def rescue_action(e) raise e end; end

class Member::TentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Member::TentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
