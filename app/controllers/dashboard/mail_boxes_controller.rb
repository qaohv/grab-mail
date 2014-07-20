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
        @job_id = Uploader::MailBoxUploader.perform_async(params[:password], params[:id])
        @mail_box.update_attributes(current_job_id: @job_id, update_status: "processing")
        p "inspect mailbox #{@mail_box.inspect}"
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
    redirect_to dashboard_path, key => message
  end

  def check_upload_status
    data = SidekiqStatus::Container.load(params[:job_id])
    p "check upload_status"
    p data.status
    render :json => { :status => data.status }
  end

  def change_job_status
    mail_box = MailBox.find_by(current_job_id: params[:job_id])
    key, message = :alert, "Произошла ошибка при загрузке писем с ящика #{mail_box.login}@#{mail_box.domain}" if params[:job_status] != "complete"
    if mail_box
      mail_box.update_attributes(update_status: params[:job_status])
      key, message = :notice, "Письма с ящика #{mail_box.login}@#{mail_box.domain} скачены."
    else
      p "Error, job doesn't exist"
    end
    redirect_to dashboard_path, key => message
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
