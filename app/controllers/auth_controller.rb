class AuthController < Devise::OmniauthCallbacksController
  # def self.provides_callback_for(provider)
  #   class_eval %Q{
  #     def #{provider}
  #       omniauth_params = request.env["omniauth.params"].with_indifferent_access
  #       @user = User.find_for_oauth(env["omniauth.auth"], current_user)

  #       if @user.persisted?
  #         sign_in_and_redirect @user, event: :authentication
  #         set_flash_message(:notice, :success, kind: #{provider}.capitalize) if is_navigational_format?
  #       else
  #         session["devise.#{provider}_data"] = env["omniauth.auth"]
  #         if params[:redirect_to]
  #           redirect_to params[:redirect_to]
  #         else
  #           redirect_to new_user_registration_url
  #         end
  #       end
  #     end
  #   }
  # end

  # [:twitter, :facebook].each do |provider|
  #   provides_callback_for provider
  # end

  def facebook
    callback_for :facebook
  end

  def destroy
    sign_out current_user
    render status: 200, nothing: true
  end

  private

  def callback_for provider
    omniauth_params = request.env["omniauth.params"].with_indifferent_access
    redirect_url = omniauth_params[:redirect_to]

    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
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


end
