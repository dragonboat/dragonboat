require File.dirname(__FILE__) + '/../../test_helper'
require 'team/website_controller'

# Re-raise errors caught by the controller.
class Team::WebsiteController; def rescue_action(e) raise e end; end

class Team::WebsiteControllerTest < Test::Unit::TestCase
  def setup
    @controller = Team::WebsiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
