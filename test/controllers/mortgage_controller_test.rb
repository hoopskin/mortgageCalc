require 'test_helper'

class MortgageControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get amortization" do
    get :amortization
    assert_response :success
  end

end
