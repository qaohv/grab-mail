class MailBox < ActiveRecord::Base
  validates :login, :pop3_server, :domain, presence: true
  belongs_to :user
end
