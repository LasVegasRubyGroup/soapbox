require 'features/features_helper'

describe "A meeting detail page, with 3 time slots, each with a topic" do
  include_context "full meeting setup"

  context "When viewed by a Visitor" do
    before { visit meeting_path(meeting) }

    it "has a 'Sign In' link" do
      page.should have_link('Sign In')
    end

    it "has the correct title" do
      page.should have_content("Meetup for")
    end

    it "contains 3 time slots" do
      page.should have_selector(:css, '.time_slot', :count => 3)
    end

    it "contains the third topic" do
      page.should have_selector(:css, "#topic_#{topic3.id}")
    end

    it "should not display graph" do 
      page.should_not have_selector("//h2", text: 'Kudos Awarded')
    end

    context "when the meeting is closed" do 
      before do
        meeting.update_attributes(state: 'closed')
      end

      it "should display a graph" do 
        visit meeting_path(meeting)
        page.should have_selector("//h2", text: 'Kudos Awarded')
      end

    end   
  end

  context "When viewed by a non-organizer User" do
    let(:user) { create(:user, :name => "Joe User", :provider => "meetup", :uid => "1234") }

    context "Voting is closed" do
      before do
        meeting.update_attributes(state: 'closed')
        signin_as(user)
        visit meeting_path(meeting)
      end

      it "should not display kudos action" do
        page.should_not have_selector(:css, ".kudos")
      end
    end

    context "when the voting is open and user" do
      before do
        meeting.open_kudos!
        signin_as(user)
      end

      context 'when the user has not voted yet' do
        it "should display kudos action" do
          visit meeting_path(meeting)
          page.should have_selector(:css, ".kudos")
        end
      end

      context 'when the user has voted' do
        before { meeting.give_kudo(meeting.topics[0], user) }
        it 'should not display kudos actions' do
          visit meeting_path(meeting)
          page.should_not have_selector(:css, ".kudos")
        end
      end
      
    end

  end
end
