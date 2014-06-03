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
    omniauth_params = request.env["omniauth.params"].with_indifferent_access
    redirect_url = omniauth_params[:redirect_to]

    @user = OmniauthUserFinder.new.(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      redirect_url ||= after_sign_in_path_for(resource)
      sign_in @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider.to_s.titleize) if is_navigational_format?
      redirect_to redirect_url
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_url ||= after_sign_in_path_for(resource)
      redirect_to redirect_url
    end
  end

  def after_sign_in_path_for(user)
    profile_path
  end

end
