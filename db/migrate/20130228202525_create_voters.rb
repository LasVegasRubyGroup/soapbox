class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.integer :user_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
