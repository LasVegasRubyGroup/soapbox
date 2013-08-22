require 'spec_helper'

describe PointsCalculator do
  subject(:calculator){PointsCalculator.new}

  describe '#calculate' do
    let(:topic){double('topic', presenter: presenter, user: suggester)}

    it 'returns an empty if given nil' do
      expect(calculator.calculate(nil)).to eq Hash.new
    end

    context 'with a topic with a presenter who is not the suggester' do
      let(:presenter){double('presenter')}
      let(:suggester){double('user')}
      let(:base_presenter_points){5}

      context 'with no kudos' do
        before { topic.stub(:kudos_count).and_return(0) }

        context 'and the topic has 4 votes' do
          before { topic.stub(:votes).and_return(4) }

          it 'gives 1 point to the suggester' do
            expect( calculator.calculate(topic)[suggester] ).to eq 1
          end

          it 'gives eight points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(3 + base_presenter_points)
          end
        end

        context 'and the topic has 8 votes' do
          before { topic.stub(:votes).and_return(8) }

          it 'gives 2 point to the suggester' do
            expect( calculator.calculate(topic)[suggester] ).to eq 2
          end

          it 'gives eleven points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(6 + base_presenter_points)
          end
        end

        context 'and the topic has 10 votes' do
          before { topic.stub(:votes).and_return(10) }

          it 'gives 2 point to the suggester' do
            expect( calculator.calculate(topic)[suggester] ).to eq 2
          end

          it 'gives thirteen points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(8 + base_presenter_points)
          end
        end
      end

      context 'with one kudo' do
        let(:kudos){1}
        before { topic.stub(:kudos_count).and_return(kudos) }

        context 'and the topic has 4 votes' do
          before { topic.stub(:votes).and_return(4) }

          it 'gives 1 point to the suggester' do
            expect( calculator.calculate(topic)[suggester] ).to eq 1
          end

          it 'gives nine points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(3 + kudos + base_presenter_points)
          end
        end
      end
    end


    context 'with a topic with a presenter who is the suggester' do
      let(:presenter){double('presenter')}
      let(:suggester){presenter}
      let(:base_presenter_points){5}

      context 'with no kudos' do
        let(:kudos){0}
        before { topic.stub(:kudos_count).and_return(kudos) }

        context 'and the topic has 4 votes' do
          before { topic.stub(:votes).and_return(4) }

          it 'gives eight points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(4 + kudos + base_presenter_points)
          end
        end

        context 'and the topic has 8 votes' do
          before { topic.stub(:votes).and_return(8) }

          it 'gives thirteen points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(8 + kudos + base_presenter_points)
          end
        end

        context 'and the topic has 10 votes' do
          before { topic.stub(:votes).and_return(10) }

          it 'gives fifteen points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(10 + kudos + base_presenter_points)
          end
        end
      end

      context 'with one kudos' do
        let(:kudos){1}
        before { topic.stub(:kudos_count).and_return(kudos) }

        context 'and the topic has 4 votes' do
          before { topic.stub(:votes).and_return(4) }

          it 'gives ten points to the presenter' do
            expect( calculator.calculate(topic)[presenter] ).to eq(4 + kudos + base_presenter_points)
          end
        end
      end
    end

  end
end