require 'net/pop'
require 'fileutils'
require 'zip'

class MailBox < ActiveRecord::Base
  include AASM

  validates :login, :pop3_server, :domain, presence: true
  validates :pop3_server, format: {with: /pop.*/, message: "pop server address should start with pop"}
  
  belongs_to :user

  has_many :emails, dependent: :destroy
  scope :uploaded_boxes, -> { where(update_status: "processing") }
  
  aasm column: 'update_status' do 
    state :empty, initial: true
    state :processing
    state :failed
    state :complete
    
    event :to_process do
      transitions from: [:empty, :failed, :complete], to: :processing, on_transition: :set_current_job_id
    end
    
    event :to_complete do
      transitions from: :processing, to: :complete
    end
    
    event :to_failed do
      transitions from: :processing, to: :failed
    end
  end

  def set_current_job_id(job_id)
     self.update_attributes(current_job_id: job_id)
  end

  class << self
    def finish_update_status
      ["complete", "failed"]
    end
  end
end
