class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.integer :topic_id
      t.integer :user_id

      t.timestamps
    end
  end
end
