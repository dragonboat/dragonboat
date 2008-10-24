require File.dirname(__FILE__) + '/../test_helper'
require 'manage_files_controller'

# Re-raise errors caught by the controller.
class ManageFilesController; def rescue_action(e) raise e end; end

class ManageFilesControllerTest < Test::Unit::TestCase
  def setup
    @controller = ManageFilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
