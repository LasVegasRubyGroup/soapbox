class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :state
      t.datetime :date

      t.timestamps
    end
  end
end
