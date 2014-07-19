#coding: utf-8
class Dashboard::MailBoxesController < Dashboard::ApplicationController
  inherit_resources
  defaults route_prefix: "dashboard"
  actions :all, except: :show
  respond_to :html

  def upload
    @mail_box = MailBox.where(id: params[:id]).first
    key, message = :notice, "Скачивание началось, это может занять некоторое время"
    begin
      if @mail_box && params[:password]
        @job_id = Uploader::MailBoxUploader.perform_async(params[:password], params[:id]) if @mail_box && params[:password]
      end
    rescue => ex
      Rails.logger.info "Caught exception: #{ex.message}"
      key = :alert
      message =
        case ex
          when Net::POPAuthenticationError
            "Неверный логин или пароль."
          when SocketError
            "Неверный адрес pop3-сервера."
          else
            "Неизвестная ошибка."
        end
    end
    @mail_boxes = current_user.mail_boxes.paginate(page: params[:page], per_page: WillPaginate.per_page)
  end

  def check_upload_status
    data = Sidekiq::Status::get_all(params[:job_id])
    p "check upload_status"
    p data
    render :json => { :status => data[:status]}
  end

  protected
    def begin_of_association_chain
      current_user
    end

    def collection
      @mail_boxes ||= end_of_association_chain.paginate(page: params[:page], per_page: WillPaginate.per_page)
    end

    def permitted_params
      params.permit(:mail_box => [:login, :pop3_server, :domain])
    end
end
