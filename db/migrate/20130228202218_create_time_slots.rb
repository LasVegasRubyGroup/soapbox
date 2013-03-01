class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.string :old_topic_id
      t.integer :meeting_id
      t.string :starts_at
      t.string :ends_at
      t.integer :topic_id
      t.integer :presenter_id

      t.timestamps
    end
  end
end
