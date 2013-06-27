class AddKudosOpenToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :kudos_open, :boolean, default: false
  end
end
