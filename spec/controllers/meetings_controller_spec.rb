require 'spec_helper'

describe MeetingsController do
  let(:organizer) { create(:organizer) }

  describe 'post :create' do
    let(:presenter) { create(:user) }
    let(:topics) { create_list(:topic, 3)}
    let(:meeting_params) do
      {
        date: Date.today,
        time_slots_attributes: {
          '0' => { starts_at: '6:20 PM', ends_at: '6:50 PM', presenter_id: presenter.id, topic_id: topics[0].id },
          '1' => { starts_at: '6:50 PM', ends_at: '7:20 PM', presenter_id: presenter.id, topic_id: topics[1].id },
          '2' => { starts_at: '7:20 PM', ends_at: '7:50 PM', presenter_id: presenter.id, topic_id: topics[2].id }
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

    it 'assigns a meeting to the topic' do
      post :create, { meeting: meeting_params }
      Topic.last.meeting.should_not be_nil
    end
  end

  describe 'get :open_kudos' do
    let(:meeting) { create(:meeting) }

    before { sign_in(organizer) }

    it 'opens the meeting for kudos' do
      get :open_kudos, id: meeting.id
      Meeting.last.should be_kudos_open
    end
  end
end
