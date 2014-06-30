class AddAttachmentToEmail < ActiveRecord::Migration
  def change
    add_attachment :emails, :attach
  end
end
