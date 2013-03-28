require 'spec_helper'

describe Topic do

  describe '#presenter_points' do
    subject(:topic) { build(:topic) }

    context 'with no kudos' do
      context 'with 10 total points and 3 suggestion points' do
        before do
          topic.stub(:points).and_return(10)
          topic.stub(:suggestion_points).and_return(3)
        end

        specify { topic.presenter_points.should == 12 }
      end

      context 'with 8 total points and 2 suggestion points' do
        before do
          topic.stub(:points).and_return(8)
          topic.stub(:suggestion_points).and_return(2)
        end

        specify { topic.presenter_points.should == 11 }
      end
    end

    context 'with 3 kudos' do
      let(:kudo_users) { [stub(:user1), stub(:user2), stub(:user3)] }

      before { topic.stub(:kudos).and_return(kudo_users) }

      context 'with 10 total points and 3 suggestion points' do
        before do
          topic.stub(:points).and_return(10)
          topic.stub(:suggestion_points).and_return(3)
        end

        specify { topic.presenter_points.should == 15 }
      end

      context 'with 8 total points and 2 suggestion points' do
        before do
          topic.stub(:points).and_return(8)
          topic.stub(:suggestion_points).and_return(2)
        end

        specify { topic.presenter_points.should == 14 }
      end
    end
  end

  describe '#give_kudo_as' do

    let(:current_user) { create(:user) }

    let(:topic) { create(:topic) }
    
    let(:meeting) { stub(:meeting, open?: true) }

    before { topic.stub(meeting: meeting) }

    it 'adds increases the count of #kudos' do
      expect { topic.give_kudo_as(current_user) }.to change(topic.kudos, :count)
    end

  end
end
