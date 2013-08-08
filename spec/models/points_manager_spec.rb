require 'spec_helper'

# PointsManager.new
  # - Takes an array of topics and an award calculator

# PointsManager#award
  # - For each topic
    # - Use a calculator to generate awards per topic
    # - Assign the awards to the topic's participants
  # - Merge and return the results

describe PointsManager do
  describe "#award" do  
    let(:points_manager) { PointsManager.new([topic], calculator) }
    context "with a topic with 4 votes" do
      before do
        topic.stub(presenter: presenter)
        topic.stub(suggester: suggester)
      end

      let(:topic) { stub(vote_count: 4) }
      context "with a presenter who is not the suggester" do
        let(:presenter) { stub(name: "Brian") } 
        let(:suggester) { stub(name: "Judd") } 
        let(:presenter_award) { double 'presenter_award' }
        let(:suggester_award) { double 'suggester_award' }
        let(:calculator) { double 'calculator' } 
       
        before do
          calculator.stub(:calculate).with(topic).and_return(presenter.name => presenter_award, suggester.name => suggester_award)
        end

        it "returns the correct number of participants" do
          expect(points_manager.award).to have(2).keys
        end
        it "returns the presenter's awarded points" do
          expect(points_manager.award[presenter.name]).to eq(presenter_award) 
        end
        it "returns the suggester's awarded points" do
          expect(points_manager.award[suggester.name]).to eq(suggester_award)
        end
      end
      context "with a presenter who is also the suggester" do
        let(:presenter) { stub(name: "Brian") } 
        let(:suggester) { presenter }
      end 
    end
  end

end
