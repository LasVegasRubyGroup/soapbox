shared_context "full meeting setup" do

  subject(:meeting) { Meeting.prototype(on_date) }
  let(:user) { create(:user) }
  let!(:presenter_one) { create(:user, :name => "Russ Smith") }
  let!(:presenter_two) { create(:user, :name => "Gabe Evans") }
  let!(:presenter_three) { create(:user, :name => "Judd Lillestrand") }
  let(:on_date) { Date.today }
  let(:topic1) { create(:topic, :title => "Topic 1", :description => "This is a topic", state: 'selected') }
  let(:topic2) { create(:topic, :title => "Topic 2", :description => "This is a topic", state: 'selected') }
  let(:topic3) { create(:topic, :title => "Topic 3", :description => "This is a topic", state: 'selected') }

  before do
    meeting.time_slots.each_with_index do |ts, idx|
      ts.presenter = User.all[idx]
      ts.topic = send("topic#{idx+1}")
    end
    meeting.save
    meeting.time_slots.each_with_index do |ts, idx|
      send("topic#{idx+1}").update_attribute(:meeting_id, meeting.id)
    end
    meeting.reload
  end

end