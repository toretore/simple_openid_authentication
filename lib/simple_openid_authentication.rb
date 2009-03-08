require "simple_authentication"
require "simple_openid_authentication/openid_authenticator"
require "simple_openid_authentication/controller_methods"

SimpleAuthentication::ControllerMethods::Logins.send(:include, SimpleOpenidAuthentication::ControllerMethods::Logins)
