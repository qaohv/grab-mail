require 'rails_helper'

describe Dashboard::MailBoxesController do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create :user
    sign_in @user
  end

  describe "index action" do
    it "get response with status code 200" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "render index template" do
      get :index
      expect(response).to render_template('index')
    end

    it "check instance variables in index action" do
      get :index
      expect(assigns(:mail_boxes)).to match_array(@user.mail_boxes)
    end
  end
end
