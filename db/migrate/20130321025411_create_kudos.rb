class CreateKudos < ActiveRecord::Migration
  def change
    create_table :kudos do |t|
      t.references :user
      t.references :topic

      t.timestamps
    end
    add_index :kudos, :user_id
    add_index :kudos, :topic_id
  end
end
