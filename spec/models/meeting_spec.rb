require 'spec_helper'

describe Meeting do
  it { should have_many(:topics) }

  context '#prototype' do
    subject { Meeting.prototype }

    it 'has a date set two weeks from now' do
      subject.date.should_not be_nil
    end
  end

  describe 'mark meeting selected after finalizing' do
    # subject { Meeting.prototype }
    # binding.pry
  end

  describe '#kudos_available?' do
    let(:on_date) { Date.today }
    subject(:meeting) { Meeting.prototype(on_date) }
    let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,50) }

    context 'at the appropriate time' do
      specify { meeting.kudos_available?(at_time).should be_true }
    end

    context 'at the appropriate time' do
      let(:at_time) { Time.local(yesterday.year, yesterday.month, yesterday.day, 19,50) }
      let(:yesterday) { 1.day.ago }
      specify { meeting.kudos_available?(at_time).should be_false }
    end

    context 'when the meeting is closed' do
      before { meeting.state = 'closed' }
      specify { meeting.kudos_available?(at_time).should be_false }
    end

    context 'at the inappropriate time' do
      let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,44) }
      specify { meeting.kudos_available?(at_time).should be_false }
    end
  end
end
