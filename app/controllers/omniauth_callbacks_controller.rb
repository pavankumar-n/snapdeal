class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  def all
    omniauth = request.env["omniauth.auth"]
    auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if auth
      flash[:notice] = "Welcome Back #{auth.user.username}"
      sign_in_and_redirect(:user, auth.user)
    else
      user = User.new
      user.email = omniauth['info']['email']
      user.name = omniauth['info']['name']
      user.authentications.build(provider: omniauth['provider'] ,uid: omniauth['uid'])
      if user.save!
        flash[:notice] = "signed in successfully"
        sign_in_and_redirect(:user, user)
      else
        redirect_to new_user_registration_url
      end
    end
  end
  alias_method :google_oauth2, :all
  alias_method :facebook, :all
end