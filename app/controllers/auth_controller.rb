class AuthController < Devise::OmniauthCallbacksController

  def facebook
    callback_for :facebook
  end

  def twitter
    callback_for :twitter
  end

  def destroy
    sign_out current_user
    render status: 200, nothing: true
  end

  private

  def callback_for provider
    @user = OmniauthUserFinder.new.(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider.to_s.titleize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
    end

    redirect_to after_sign_in_path_for(resource)
  end

  def after_sign_in_path_for(user)
    omniauth_params = request.env["omniauth.params"].with_indifferent_access
    redirect_to_url = omniauth_params[:redirect_to] unless omniauth_params[:redirect_to].blank?
    uri = URI.parse(redirect_to_url || profile_path)
    uri.query = [uri.query, "token=#{token}"].join '&'
    uri.to_s
  end

  def token
    request.env["omniauth.auth"].credentials.token
  end

end
