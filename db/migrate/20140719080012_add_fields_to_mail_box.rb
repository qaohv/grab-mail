class AddFieldsToMailBox < ActiveRecord::Migration
  def change
    add_column :mail_boxes, :update_status,  :string
    add_column :mail_boxes, :current_job_id, :text
  end
end
