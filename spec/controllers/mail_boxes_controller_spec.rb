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

    it "render template" do
      get :index
      expect(response).to render_template('index')
    end

    it "check instance variables" do
      get :index
      expect(assigns(:mail_boxes)).to match_array(@user.mail_boxes)
    end
  end


  describe "create action" do
    it "redirect to index page after successfully mail_box creating" do
      expect {
        post :create, mail_box: { login: "dns.ryabokon", domain: "google.com", pop3_server: "pop3.google.com" }
      }.to change(MailBox,:count).by(1)
    end

    it "render new page when fail in create action" do
      post :create, {}
      expect(response).to render_template('new')
    end
  end
end
