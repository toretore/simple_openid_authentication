module SimpleOpenidAuthentication


  module ControllerMethods


    module Logins


    private

      def openid_authentication
        authenticate_with_open_id openid_authentication_url, openid_authentication_options do |result, identity_url, registration|
          if result.successful?
            authenticate_openid_user(identity_url, registration)
          else
            authentication_failed result.message
          end
        end
      end

      def authenticate_openid_user(identity_url, registration)
        user = User.find_or_initialize_by_openid_identifier(identity_url)

        #Add or update attributes provided by the OpenID server
        model_to_registration_mapping.each do |attr,reg_key|
          user.send("#{attr}=", registration[reg_key])
        end

        if user.save
          self.current_user = user
          authentication_successful
        else
          authentication_failed I18n.t('simple_openid_authentication.could_not_save_user')
        end
      end

      def openid_authentication_url
        params[:openid_identifier]
      end

      def openid_authentication_options(opts={})
        {
          :return_to => login_url(:authenticator => "openid") #open_id_authentication will fake a POST
        }.merge(openid_registration_options).merge(opts)
      end

      #Which attributes to request from the provider using the Simple Registration Extension
      #They can be :optional or :required
      def openid_registration_options
        {:optional => [:fullname, :email]}
      end

      #Which attributes on the user object receives which SReg attributes
      def model_to_registration_mapping
        #{:model => 'server'}
        {:name => 'fullname', :email => 'email'}
      end


    end


  end


end
