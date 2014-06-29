require 'net/pop'

class MailBox < ActiveRecord::Base
  validates :login, :pop3_server, :domain, presence: true
  validates :pop3_server, format: {with: /pop3.*/, message: "pop3 server address should start with pop3"}
  belongs_to :user

  has_many :emails

  def get_emails(password)
    p "work get emails"
    pop = Net::POP3.new self.pop3_server
    pop.start "#{self.login}@#{self.domain}", password
    unless pop.mails.empty?
      pop.each_mail do |mail|
        email, args = Mail.new(mail.pop), {}
        [:from, :to, :subject, :message_id].each { |field|  args[field] = email.send(field).to_s }
        text = email.html_part ? email.html_part : email.text_part
        args[:body] = text.decoded.force_encoding("utf-8")
        p args
        email =  self.emails.create!(args) rescue nil
      end
    end
  end
end
