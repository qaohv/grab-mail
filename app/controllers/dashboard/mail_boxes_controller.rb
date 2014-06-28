#coding: utf-8
class Dashboard::MailBoxesController < Dashboard::ApplicationController
  inherit_resources
  defaults route_prefix: "dashboard"
  actions :all, except: :show
  respond_to :html

  def update
    p "this is update method"
    p params
  end

  protected
    def begin_of_association_chain
      current_user
    end

    def permitted_params
      params.permit(:mail_box => [:login, :pop3_server, :domain])
    end
end
