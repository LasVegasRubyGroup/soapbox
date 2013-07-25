require 'spec_helper'

describe PointsManager do
  describe "#award" do  
    let(:points) { PointsManager.new([topic]) }

    context "with a topic with 4 votes" do
      let(:topic) { stub(vote_count: 4) }
      context "with a presenter who is also the suggester" do
        let(:person) { stub(name: "Brian") }
        before do
          topic.stub(presenter: person)
          topic.stub(suggester: person)
        end
        context "for a non-freshman presenter" do
          let(:points_record) { PointsRecord.new } 
          it "awards 4 points to the presenter" do
            expect(points.award).to include({ topic.presenter.name => points_record }) 
          end
        end
        context "for a freshman presenter" do
          it "awards 14 points to the presenter" do

          end
        end 
      end 
    end
  end

end
