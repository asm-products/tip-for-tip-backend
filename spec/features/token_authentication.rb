require 'spec_helper.rb'

class DummyController < ApplicationController
  include TokenAuthentication
  rescue_from ActionView::MissingTemplate, with: -> {}
  before_filter :authenticate_user_from_token!
  def index; end
end

describe "Token Authentication" do
  subject { DummyController }

  before { Rails.application.routes.draw { get '/dummy', to: 'dummy#index' } }
  after  { Rails.application.reload_routes! }

  it "authenticates a request using a identity token" do
    visit '/dummy'
    expect(page.status_code).to eq 401
    user = FactoryGirl.create :user, :with_identity
    visit "/dummy?token=#{user.identities.first.token}"
    expect(page.status_code).to eq 200
  end

end
