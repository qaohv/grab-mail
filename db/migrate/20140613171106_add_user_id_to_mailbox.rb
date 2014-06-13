class AddUserIdToMailbox < ActiveRecord::Migration
  def change
    add_column :mail_boxes, :user_id, :integer
  end
end
