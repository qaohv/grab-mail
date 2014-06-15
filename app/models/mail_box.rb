class MailBox < ActiveRecord::Base
  validates :login, :pop3_server, :domain, presence: true
  validates :pop3_server, format: {with: /pop3.*/, message: "pop3 server address should start with pop3"}
  belongs_to :user
end
