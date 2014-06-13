class CreateMailBoxes < ActiveRecord::Migration
  def change
    create_table :mail_boxes do |t|
      t.string :login
      t.string :pop3_server
      t.string :domain
      t.timestamps
    end
  end
end
