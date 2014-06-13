#coding: utf-8
class Dashboard::MailBoxesController < Dashboard::ApplicationController
  inherit_resources
  defaults route_prefix: "dashboard"
  respond_to :html

  protected
    def begin_of_association_chain
      current_user
    end
end
