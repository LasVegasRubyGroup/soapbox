require 'spec_helper'

describe MeetingDecorator do
  include Draper::ViewHelpers

  let(:meeting) { create(:meeting, date: Date.new(2013, 10, 10)) }
  subject(:decorator) { MeetingDecorator.new(meeting) }

  describe '#meeting_date' do
    specify do
      Timecop.freeze(meeting.date) do
        decorator.meeting_date.should eq 'October 10, 2013'
      end
    end
  end

  describe '#kudo_links_for' do
    before { Time.stub(:now).and_return(at_time) }

    context 'when kudos are available', :full_meeting do
      let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,50) }

      it 'displays kudo links' do
        Timecop.freeze(at_time) do
          h.should_receive(:render).with('kudo_links')
          decorator.kudo_links_for(user)
        end
      end
    end

    context 'when kudos are not available', :full_meeting do
      let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,00) }

      it 'displays kudo links' do
        h.should_not_receive(:render).with('kudo_links')
        decorator.kudo_links_for(user)
      end
    end
  end

  describe '#points_awarded' do
    context 'when meeting is closed' do
      before do
        meeting.update_attributes(state: 'closed')
      end

      it 'displays points awarded' do
        h.should_receive(:render).with('points_awarded')
        decorator.points_awarded
      end
    end

    context 'when meeting is not closed' do
      it 'does not display points awarded' do
        h.should_not_receive(:render).with('points_awarded')
        decorator.points_awarded
      end
    end
  end
end
