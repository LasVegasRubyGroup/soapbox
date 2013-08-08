require 'features/features_helper'
describe "A meeting detail page, with 3 time slots, each with a topic" do
  include_context "full meeting setup"

  context "When viewed by an organizer" do
    let(:organizer) { create(:organizer) }
    before do 
      signin_as(organizer)
      visit meeting_path(meeting)
    end
 
    it "contains a 'create meeting' link" do
      expect(page).to have_link("Create Meeting")
    end

    it "contains an 'edit meeting' link" do
      expect(page).to have_link("Edit Meeting")
    end

    it "contains a 'finalize meeting' link" do
      expect(page).to have_link("Finalize")
    end

    it "contains an 'open kudos' link" do
      expect(page).to have_link("Open this Meeting for Voting")
    end

    context "with one freshman presenter" do
      before do
        TimeSlot.create(presenter_id: presenter_two.id) 
        TimeSlot.create(presenter_id: presenter_three.id) 
        click_link("Finalize")
      end

      it "awards bonus points to the freshman presenter" do
        expect(page).to have_text("Russ Smith awarded 10 bonus points!")
      end
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
end
