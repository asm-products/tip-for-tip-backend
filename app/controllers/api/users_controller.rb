module Api
  class UsersController < ApplicationController
    include TokenAuthentication

    before_filter :authenticate_user_from_token!
    before_filter :authenticate_user!

    def profile
    end

  end
end
