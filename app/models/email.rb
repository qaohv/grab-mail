#coding: utf-8
class Email < ActiveRecord::Base
  validate :message_id, presence:   true,
                        uniqueness: true

  validate :from, presence: true

  belongs_to :mail_box
end
