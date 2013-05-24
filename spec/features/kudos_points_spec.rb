require 'features/features_helper'

describe "A meeting detail page, with 3 time slots, each with a topic" do
  let!(:presenter_one) { create(:user, :name => "Russ Smith") }
  let!(:presenter_two) { create(:user, :name => "Gabe Evans") }
  let!(:presenter_three) { create(:user, :name => "Judd Lillestrand") }


  let(:on_date) { Date.today }
  let(:meeting) { Meeting.prototype(on_date) }
  let(:topic1) { create(:topic, :title => "Topic 1", :description => "This is a topic", state: 'selected') }
  let(:topic2) { create(:topic, :title => "Topic 2", :description => "This is a topic", state: 'selected') }
  let(:topic3) { create(:topic, :title => "Topic 3", :description => "This is a topic", state: 'selected') }

  before do
    meeting.time_slots.each_with_index do |ts, idx|
      ts.presenter = User.all[idx]
      ts.topic = send("topic#{idx+1}")
      FactoryGirl.create_list(:kudo, idx, topic_id: ts.topic.id)
    end
    meeting.save
    meeting.time_slots.each_with_index do |ts, idx|
      send("topic#{idx+1}").update_attribute(:meeting_id, meeting.id)
    end
    meeting.reload    
  end

  context 'when awarding kudos points' do 
    let(:user) { create(:user, :name => "Joe User", :provider => "meetup", :uid => "1234") }
    before do
      signin_as(user)
      user.organizer = true
      user.save
    end

    it "it should should show Judd's 7 points on the leaderboard" do
      visit meeting_path(meeting)
      click_link 'Finalize'
      visit leaderboard_path
      page.should have_content '1 Judd Lillestrand 7'
    end
  end


end