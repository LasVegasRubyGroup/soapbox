require 'features/features_helper'

describe "A meeting detail page, with 3 time slots, each with a topic" do
  let(:presenter) { create(:user, :name => "Presenter") }
  let(:on_date) { Date.today }
  let(:meeting) { Meeting.prototype(on_date) }
  let(:topic1) { create(:topic, :title => "Topic 1", :description => "This is a topic") }
  let(:topic2) { create(:topic, :title => "Topic 2", :description => "This is a topic") }
  let(:topic3) { create(:topic, :title => "Topic 3", :description => "This is a topic") }

  before do
    meeting.time_slots.each_with_index do |ts, idx|
      ts.presenter = presenter
      ts.topic = send("topic#{idx+1}")
    end
    meeting.save
  end

  context "When viewed by a Visitor" do
    before { visit meeting_path(meeting) }

    it "has a 'Sign In' link" do
      page.should have_link('Sign In')
    end

    it "has the correct title" do
      page.should have_content("@LVRUG Meetup for #{on_date}")
    end

    it "contains 3 time slots" do
      page.should have_selector(:css, '.time_slot', :count => 3)
    end

    it "contains the third topic" do
      page.should have_selector(:css, "#topic_#{topic3.id}")
    end
  end
end
