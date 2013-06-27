require 'features/features_helper'

describe "A meeting detail page, with 3 time slots, each with a topic" do
  include_context "full meeting setup"

  before do
    meeting.open_kudos!
    meeting.time_slots.each_with_index do |ts, idx|
      FactoryGirl.create_list(:kudo, idx, topic_id: ts.topic.id)
    end
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
