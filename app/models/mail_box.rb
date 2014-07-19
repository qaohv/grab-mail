require 'net/pop'
require 'fileutils'
require 'zip'

class MailBox < ActiveRecord::Base
  validates :login, :pop3_server, :domain, presence: true
  validates :pop3_server, format: {with: /pop.*/, message: "pop server address should start with pop"}
  belongs_to :user

  has_many :emails, dependent: :destroy
  scope :uploaded_boxes, -> { where(update_status: "processing") }
end
