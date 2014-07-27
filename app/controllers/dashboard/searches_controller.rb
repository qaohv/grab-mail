# coding: utf-8

class Dashboard::SearchesController < Dashboard::ApplicationController
  def simple
    unless params[:query].blank?
      @query = params[:query] 
      @emails = Email.search @query, page: params[:page], per_page: WillPaginate.per_page
    end
  end
end
