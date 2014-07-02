#coding: utf-8
class Dashboard::EmailsController < Dashboard::ApplicationController
  inherit_resources
  belongs_to :mail_box
  defaults :route_prefix => "dashboard"
  respond_to :html

  protected
    def begin_of_association_chain
      current_user
    end
end
