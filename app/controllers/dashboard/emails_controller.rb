#coding: utf-8
class Dashboard::EmailsController < Dashboard::ApplicationController
  inherit_resources
  belongs_to :mail_box
  defaults :route_prefix => "dashboard"
  respond_to :html

  protected
    def collection
      @emails ||= end_of_association_chain.paginate(page: params[:page], per_page: WillPaginate.per_page)
    end
end
