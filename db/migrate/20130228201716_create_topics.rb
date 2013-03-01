class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :old_id
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :state
      t.integer :meeting_id

      t.timestamps
    end
  end
end
