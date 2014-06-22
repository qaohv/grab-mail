require 'rails_helper'

describe Dashboard::MailBoxesController do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create :user
    sign_in @user
    @mail_box = @user.mail_boxes.create!(login: "dns.ryabokon", pop3_server: "pop3.google.com", domain: "google.com")
  end

  class << self
    def get_response_status_code_200(*actions)
      actions.each do |action|
        it "get response with status code 200 for action #{action}" do
          args = action == :edit ? { id: @mail_box.id } : {}
          process action, 'GET', args
          expect(response).to be_success
          expect(response.status).to eq(200)
        end
      end
    end
  end

  get_response_status_code_200(:index, :new, :edit)

  describe "index action" do
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

  describe "destroy action" do
    it "delete action" do
      mail_box = @user.mail_boxes.create!(login: "dns.ryabokon", pop3_server: "pop3.google.com", domain: "google.com")
      expect {
        delete :destroy, id: mail_box.id
      }.to change(MailBox,:count).by(-1)
    end
  end


  describe "edit action" do
    it "check instance variables" do
      mail_box = @user.mail_boxes.create!(login: "dns.ryabokon", pop3_server: "pop3.google.com", domain: "google.com")
      get :edit, id: mail_box.id
      expect(assigns(:mail_box)).to match(mail_box)
    end

    it "render 404 page if object doen't exist" do
    end
  end
end
