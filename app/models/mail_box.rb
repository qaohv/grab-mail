require 'net/pop'

class MailBox < ActiveRecord::Base
  validates :login, :pop3_server, :domain, presence: true
  validates :pop3_server, format: {with: /pop3.*/, message: "pop3 server address should start with pop3"}
  belongs_to :user

  def get_emails(password)
    p "work get emails"
    pop = Net::POP3.new self.pop3_server
    pop.start "#{self.login}@#{self.domain}", password
    if pop.mails.empty?
        p "No new mails"
    else
      pop.each_mail do |mail|
        email = Mail.new(mail.pop)
        p email.from
        p email.to
        p email.subject
        text = email.html_part ? email.html_part : email.text_part
        p text.decoded.force_encoding("utf-8")
        p email.message_id
        email.attachments.each do |attachment|
          p attachment.content_type
          filename = attachment.filename
        end
      end
    end
  end
end
