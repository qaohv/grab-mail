class CreateEmail < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string     :to
      t.string     :from
      t.string     :subject
      t.text       :body
      t.string     :message_id
      t.integer    :mail_box_id
      t.timestamps
    end
  end
end
