require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/files_controller'

# Re-raise errors caught by the controller.
class Admin::FilesController; def rescue_action(e) raise e end; end

class Admin::FilesControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::FilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
