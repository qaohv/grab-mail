#coding: utf-8
class Email < ActiveRecord::Base
  validates :message_id, presence:   true,
                        uniqueness: true

  validates :from, :mail_box, presence: true

  belongs_to :mail_box

  has_attached_file :attach,
                    :url => "/system/:id.:extension"
  validates_attachment_content_type :attach, content_type: "application/zip"
end
