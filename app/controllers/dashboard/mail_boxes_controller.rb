#coding: utf-8
class Dashboard::MailBoxesController < Dashboard::ApplicationController
  inherit_resources
  defaults route_prefix: "dashboard"
  actions :all, except: :show
  respond_to :html

  def upload
    mail_box = MailBox.where(id: params[:id]).first
    key, message = :notice, "Скачивание началось, это может занять некоторое время"
    begin
      mail_box.get_emails(params[:password]) if mail_box
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

  protected
    def begin_of_association_chain
      current_user
    end

    def permitted_params
      params.permit(:mail_box => [:login, :pop3_server, :domain])
    end
end
