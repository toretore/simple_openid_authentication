require 'rubygems'
require 'test/unit'
require 'mocha'

module SimpleAuthentication
  class Authenticator
    attr_accessor :controller
    def initialize(c)
      self.controller = c
    end
    def params
      controller.params
    end
  end
end

require 'simple_openid_authentication/openid_authenticator'

class MockController
  def params
    @params ||= {}
  end
end

class OpenidAuthenticatorTest < Test::Unit::TestCase

  def setup
    @controller = MockController.new
    @auth = SimpleAuthentication::OpenidAuthenticator.new(@controller)
  end

  def test_authentication_should_be_possible_when_openid_identifier_present
    @controller.params[:openid_identifier] = 'humbaba'
    assert @auth.authentication_possible?
  end

  def test_authentication_should_be_possible_when_open_id_complete_present
    @controller.params[:open_id_complete] = 'humbaba'
    assert @auth.authentication_possible?
  end

  def test_authenticate_should_run_openid_authentication_on_controller
    @controller.params[:openid_identifier] = 'humbaba'
    @controller.expects(:openid_authentication)
    @auth.authenticate
  end

end
