require 'spec_helper'

describe Meeting do
  it { should have_many(:topics) }

  context '#prototype' do
    subject { Meeting.prototype }

    it 'has a date set two weeks from now' do
      subject.date.should_not be_nil
    end
  end

  describe '#open_kudos!' do
    it 'sets the meeting to be open for kudos' do
      subject.open_kudos!
      subject.should be_kudos_open
    end
  end

  describe '#close_kudos!' do
    it 'sets the meeting to be closed for kudos' do
      subject.close_kudos!
      subject.should_not be_kudos_open
    end
  end

  context '#finalize_and_reward' do
    it 'finalizes the meeting' do
      subject.should_receive(:finalize!)
      subject.finalize_and_reward!
    end

    it 'marks topics as closed' do
      subject.should_receive(:mark_topics_closed!)
      subject.finalize_and_reward!
    end

    it 'gives points' do
      subject.should_receive(:give_points!)
      subject.finalize_and_reward!
    end

    it 'closes kudos' do
      subject.should_receive(:close_kudos!)
      subject.finalize_and_reward!
    end
  end

  describe 'mark meeting selected after finalizing' do
    # subject { Meeting.prototype }
    # binding.pry
  end

  describe '#can_give_kudo?' do
    include_context "full meeting setup"

    context 'when the user has given a kudo' do
      before { topic1.give_kudo_as(user) ; meeting.reload }

      specify { meeting.can_give_kudo?(user).should be_false }
    end

  end

  describe '#give_kudo' do
    include_context "full meeting setup"

    it 'gives a kudo for a user who has not already given' do
      expect { meeting.give_kudo(topic1, user) }.to change(Kudo, :count)
    end

  end

  describe '#kudos_available?' do
    include_context "full meeting setup"

    context 'when meeting already has kudos set to be open' do
      specify 'at anytime, allows kudos' do
        meeting.open_kudos!
        meeting.kudos_available?(Time.now, user).should be_true
      end
    end

    let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,50) }

    context 'at the inappropriate time' do
      let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,44) }
      specify { meeting.kudos_available?(at_time, user).should be_false }
    end

    context 'at the appropriate time' do
      let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,50) }
      context 'when the user has not voted' do
        specify { meeting.kudos_available?(at_time, user).should be_true }
      end

      context 'when the user has voted' do
        before { meeting.give_kudo(meeting.topics[0], user) ; meeting.reload }
        specify { meeting.kudos_available?(at_time, user).should be_false }
      end
    end

    context 'when on the wrong date' do
      let(:at_time) { Time.local(yesterday.year, yesterday.month, yesterday.day, 19,50) }
      let(:yesterday) { 1.day.ago }
      specify { meeting.kudos_available?(at_time, user).should be_false }
    end

    context 'when the meeting is closed' do
      before { meeting.state = 'closed' }
      specify { meeting.kudos_available?(at_time, user).should be_false }
    end


  end
end


