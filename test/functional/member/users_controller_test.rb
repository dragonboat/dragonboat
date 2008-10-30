require File.dirname(__FILE__) + '/../../test_helper'
require 'member/users_controller'

# Re-raise errors caught by the controller.
class Member::UsersController; def rescue_action(e) raise e end; end

class Member::UsersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Member::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
