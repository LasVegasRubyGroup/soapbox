require 'spec_helper'

describe MeetingsController do

  describe 'post :create' do
    let(:organizer) { create(:organizer) }
    let(:presenter) { create(:user) }
    let(:topic) { create(:topic)}
    let(:meeting_params) do
      { 
        date: Date.today,
        time_slots_attributes: {
          '0' => { starts_at: '6:20 PM', ends_at: '6:50 PM', presenter_id: presenter.id, topic_id: topic.id },
          '1' => { starts_at: '6:50 PM', ends_at: '7:20 PM', presenter_id: presenter.id, topic_id: topic.id },
          '2' => { starts_at: '7:20 PM', ends_at: '7:50 PM', presenter_id: presenter.id, topic_id: topic.id }
        }
      }
    end

    before { sign_in(organizer) }

    it 'creates a meeting' do
      expect{ post :create, { meeting: meeting_params } }.to( 
        change(Meeting, :count).by(1))
    end

    it 'the meeting will have three time slots' do
      post :create, { meeting: meeting_params }
      Meeting.first.should have(3).time_slots
    end

    it 'marks the topics as selected' do
      post :create, { meeting: meeting_params }
      Topic.last.should be_selected
    end

  end
end
