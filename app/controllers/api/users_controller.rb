module Api
  class UsersController < ApplicationController

    before_filter :authenticate_user!

    respond_to :json

    def profile
    end

  end
end
