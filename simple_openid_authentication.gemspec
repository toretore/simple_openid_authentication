Gem::Specification.new do |s|
  s.name     = "simple_openid_authentication"
  s.version  = "0.1.3"
  s.date     = "2009-03-16"
  s.summary  = "OpenID authentication for SimpleAuthentication"
  s.email    = "toredarell@gmail.com"
  s.homepage = "http://github.com/toretore/simple_openid_authentication"
  s.description = "OpenID authentication for SimpleAuthentication"
  #s.has_rdoc = true
  s.author  = "Tore Darell"
  #s.files    = Dir["lib/**/*"] + Dir["rails/**/*"] + Dir["config/**/*"] + Dir["app/**/*"] + Dir["generators/**/*"] + Dir["tasks/**/*"]
  s.files   = %w(lib/simple_openid_authentication lib/simple_openid_authentication/openid_authenticator.rb lib/simple_openid_authentication/controller_methods.rb lib/simple_openid_authentication.rb rails/uninstall.rb rails/install.rb rails/init.rb config/locales config/locales/simple_openid_authentication.yml app/views app/views/logins app/views/logins/openid.html.erb generators/simple_openid_authentication generators/simple_openid_authentication/USAGE generators/simple_openid_authentication/templates generators/simple_openid_authentication/simple_openid_authentication_generator.rb tasks/simple_openid_authentication_tasks.rake)
  #s.rdoc_options = ["--main", "README.txt"]
  #s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.add_dependency("toretore-simple_authentication", ["= 0.1.3"])
end
