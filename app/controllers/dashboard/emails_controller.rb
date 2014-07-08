#coding: utf-8
class Dashboard::EmailsController < Dashboard::ApplicationController
  inherit_resources
  before_filter :check_permissions
  belongs_to :mail_box
  defaults :route_prefix => "dashboard"
  respond_to :html

  protected
    def collection
      @emails ||= end_of_association_chain.paginate(page: params[:page], per_page: WillPaginate.per_page)
    end

    def check_permissions
      mailbox = MailBox.find_by_id(params[:mail_box_id])
      if mailbox
        redirect_to dashboard_path, alert: "Permission denied." unless mailbox.user_id == current_user.id
      else
        redirect_to dashboard_path, alert: "Mail box with id #{params[:mail_box_id]} doesn't exist."
      end
    end
end
