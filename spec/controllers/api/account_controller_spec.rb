require 'spec_helper.rb'

describe Api::AccountController do
  before { accept_json }
  let!(:user) { user = stub_token_authentication }

  describe '#purchases' do
    before { FactoryGirl.create :purchase, user: user }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    # Success
    it 'responds with success' do
      get :purchases
      expect(response.status).to eq 200
    end

    it 'renders the purchases view' do
      expect(get :purchases).to render_template :purchases
    end

    it 'orders purchases by created_at descending' do
      FactoryGirl.create :purchase, user: user, created_at: 2.days.ago
      FactoryGirl.create :purchase, user: user, created_at: 1.day.ago
      get :purchases
      dates = user.purchases.pluck(:created_at).sort.reverse
      expect(assigns(:purchases).collect(&:created_at)).to eq dates
    end
  end

  describe '#sales' do
    before { FactoryGirl.create :purchase, tip: FactoryGirl.create(:tip, user: user) }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    # Success
    it 'responds with success' do
      get :sales
      expect(response.status).to eq 200
    end

    it 'renders the sales view' do
      expect(get :sales).to render_template :sales
    end

    it 'orders sales by created_at descending' do
      FactoryGirl.create :purchase, tip: FactoryGirl.create(:tip, user: user), created_at: 2.days.ago
      FactoryGirl.create :purchase, tip: FactoryGirl.create(:tip, user: user), created_at: 1.day.ago
      get :sales
      dates = user.sales.pluck(:created_at).sort.reverse
      expect(assigns(:sales).collect(&:created_at)).to eq dates
    end
  end

end
