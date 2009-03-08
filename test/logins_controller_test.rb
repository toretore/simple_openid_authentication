require 'rubygems'
require 'test/unit'
require 'mocha'
require 'simple_openid_authentication/controller_methods'

class MockController
  attr_accessor :current_user, :authentication_failed_called, :authentication_successful_called
  include SimpleOpenidAuthentication::ControllerMethods::Logins
  def params
    @params ||= {}
  end
  def session
    @session ||= {}
  end
  def authentication_successful(*a)
    self.authentication_successful_called = true
  end
  def authentication_failed(*a)
    self.authentication_failed_called = true
  end
end

class User
  attr_accessor :url, :name, :email, :save_should_succeed, :awesome
  def initialize(url)
    self.url = url
  end
  def save
    save_should_succeed
  end
end

class LoginsControllerTest < Test::Unit::TestCase

  def setup
    @controller = MockController.new
  end


  def test_openid_authentication_url_should_return_openid_identifier_param
    @controller.params[:openid_identifier] = "humbaba"
    assert_equal "humbaba", @controller.send(:openid_authentication_url)
  end

  def test_authenticate_openid_user_should_set_current_user
    u = User.new('humbaba')
    u.save_should_succeed = true
    User.expects(:find_or_initialize_by_openid_identifier).returns(u)
    @controller.send(:authenticate_openid_user, "humbaba", {})
    assert_equal u, @controller.current_user
  end

  def test_authenticate_openid_user_should_transfer_registration_values_to_user
    u = User.new('humbaba')
    u.save_should_succeed = true
    User.expects(:find_or_initialize_by_openid_identifier).returns(u)
    @controller.send(:authenticate_openid_user, "humbaba", {'fullname' => "Humbaba", 'email' => "humbaba@forest"})
    assert_equal u, @controller.current_user
    assert_equal "Humbaba", u.name
    assert_equal "humbaba@forest", u.email
  end

  def test_authenticate_openid_user_should_only_transfer_registration_values_from_mapping
    u = User.new('humbaba')
    u.save_should_succeed = true
    User.expects(:find_or_initialize_by_openid_identifier).returns(u)
    @controller.send(:authenticate_openid_user, "humbaba", {'awesome' => 'yes'})
    assert_equal u, @controller.current_user
    assert_nil u.awesome
  end

  def test_authenticate_openid_user_should_succeed_if_user_can_be_saved
    u = User.new('humbaba')
    u.save_should_succeed = true
    User.expects(:find_or_initialize_by_openid_identifier).returns(u)
    @controller.send(:authenticate_openid_user, "humbaba", {})
    assert_equal u, @controller.current_user
    assert @controller.authentication_successful_called
  end

  def test_authenticate_openid_user_should_fail_if_user_cant_be_saved
    u = User.new('humbaba')
    u.save_should_succeed = false
    User.expects(:find_or_initialize_by_openid_identifier).returns(u)
    @controller.send(:authenticate_openid_user, "humbaba", {})
    assert_nil @controller.current_user
    assert @controller.authentication_failed_called
  end

  def test_openid_authentication_should_call_authenticate_openid_user_on_success
    result = Class.new do
      def successful?; true; end
    end.new
    @controller.params[:openid_identifier] = 'humbaba'
    @controller.expects(:authenticate_with_open_id).yields(result, 'humbaba', {})
    @controller.expects(:authenticate_openid_user)
    @controller.expects(:login_url)
    @controller.send(:openid_authentication)
  end

  def test_openid_authentication_should_call_authentication_failed_on_failure
    result = Class.new do
      def successful?; false; end
      def message; 'you can not touch the cedars'; end
    end.new
    @controller.params[:openid_identifier] = 'humbaba'
    @controller.expects(:authenticate_with_open_id).yields(result, 'humbaba', {})
    @controller.expects(:authentication_failed).with('you can not touch the cedars')
    @controller.expects(:login_url)
    @controller.send(:openid_authentication)
  end


end
