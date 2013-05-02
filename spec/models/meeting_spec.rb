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

  describe '#can_give_kudo?' do
    let(:user) { create(:user) }
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
      meeting.time_slots.each_with_index do |ts, idx|
        send("topic#{idx+1}").update_attribute(:meeting_id, meeting.id)
      end
    end

    context 'when the user has given a kudo' do
      before { topic1.give_kudo_as(user) ; meeting.reload }

      specify { meeting.can_give_kudo?(user).should be_false }
    end

  end

  describe '#give_kudo' do
    let(:user) { create(:user) }
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
      meeting.time_slots.each_with_index do |ts, idx|
        send("topic#{idx+1}").update_attribute(:meeting_id, meeting.id)
      end
    end

    it 'gives a kudo for a user who has not already given' do
      expect { meeting.give_kudo(topic1, user) }.to change(Kudo, :count)
    end

  end

  describe '#kudos_available?' do
    let(:user) { create :user }
    let(:presenter) { create(:user, :name => "Presenter") }
    let(:on_date) { Date.today }
    let(:at_time) { Time.local(on_date.year, on_date.month, on_date.day, 19,50) }
    subject(:meeting) { Meeting.prototype(on_date) }
    let(:topic1) { create(:topic, :title => "Topic 1", :description => "This is a topic") }
    let(:topic2) { create(:topic, :title => "Topic 2", :description => "This is a topic") }
    let(:topic3) { create(:topic, :title => "Topic 3", :description => "This is a topic") }

    before do
      meeting.time_slots.each_with_index do |ts, idx|
        ts.presenter = presenter
        ts.topic = send("topic#{idx+1}")
      end
      meeting.save
      meeting.time_slots.each_with_index do |ts, idx|
        send("topic#{idx+1}").update_attribute(:meeting_id, meeting.id)
      end
      meeting.reload
    end

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


