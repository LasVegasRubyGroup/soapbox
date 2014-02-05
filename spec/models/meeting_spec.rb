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
  end

  describe '#can_give_kudo?' do
    subject(:meeting) { Meeting.new }
    let(:user) { double(:user) }
    let(:topic_with_kudo) { double(:topic, given_kudo?: true) }
    let(:topic_without_kudo) { double(:topic, given_kudo?: false) }

    before do
      meeting.stub(:topics).and_return(topics)
    end

    context 'when the user has given a kudo' do
      let(:topics) { [topic_with_kudo] }

      specify { meeting.given_kudo?(user).should be_true }
    end

    context 'when the user has not given a kudo' do
      let(:topics) { [topic_without_kudo] }

      specify { meeting.given_kudo?(user).should be_false }
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

    context 'when kudos are set to open' do
      before { meeting.open_kudos! }

      context 'when the user has not voted' do
        specify do
          meeting.kudos_available?(user).should be_true
        end
      end

      context 'when the user has voted' do
        before { meeting.give_kudo(meeting.topics[0], user) ; meeting.reload }
        specify do
          meeting.kudos_available?(user).should be_false
        end
      end
    end

    context 'prior to kudos being set to open' do
      specify do
        meeting.kudos_available?(user).should be_false
      end
    end

    context 'when the meeting is closed' do
      before { meeting.state = 'closed' }
      specify do
        meeting.kudos_available?(user).should be_false
      end
    end
  end
end
