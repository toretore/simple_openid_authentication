module SimpleAuthentication

  class OpenidAuthenticator < Authenticator


    def authentication_possible?
      params.include?(:openid_identifier) || params.include?(:open_id_complete)
    end


    def authenticate
      controller.send :openid_authentication
      
      :ok
    end


  end

end
