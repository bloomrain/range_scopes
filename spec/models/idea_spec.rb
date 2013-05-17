require 'spec_helper'

describe Idea do
  describe "between_price" do
    context "when idea has no default prices" do
      before do
        @idea = create(:idea, price_from: nil, price_till: nil)
      end
      it "should return idea no mather what prices are given in search" do
        Idea.between_price(nil, nil).should  == [@idea]
        Idea.between_price(0, nil).should    == [@idea]
        Idea.between_price(100, nil).should  == [@idea]
        Idea.between_price(nil, 0).should    == [@idea]
        Idea.between_price(nil, 9000).should == [@idea]
        Idea.between_price(100, 9000).should == [@idea]
      end
    end

    context "when idea has only price from" do
      before do
        @idea = create(:idea, price_from: 100, price_till: nil)
      end

      it "skips idea if price_till in search is less than idea price from" do
        Idea.between_price(nil, 99).should  be_empty
        Idea.between_price(0, 99).should  be_empty
      end

      it 'returns idea if search prices are empty' do
        Idea.between_price(nil, nil).should  == [@idea]
      end

      it 'returns idea if search price till is nil or zero' do
        Idea.between_price(50, nil).should    == [@idea]
        Idea.between_price(50, 0).should    == [@idea]
      end

      it 'returs idea if search price till is bigger than ideas price from' do
        Idea.between_price(nil, 9000).should == [@idea]
        Idea.between_price(50, 9000).should == [@idea]
      end
    end

    context "when idea has only price till" do
      before do
        @idea = create(:idea, price_from: nil, price_till: 100)
      end

      it 'skips idea if search price from is bigger than idea price till' do
        Idea.between_price(101, nil).should be_empty
        Idea.between_price(101, 200).should be_empty
      end
      it 'returns idea if search prices are not given or equal to zero' do
        Idea.between_price(nil, nil).should == [@idea]
        Idea.between_price(0, 0).should == [@idea]
      end

      it 'returns idea if search price from is less or equal to idea price till' do
        Idea.between_price(100, nil).should == [@idea]
        Idea.between_price(50, 200).should == [@idea]
      end

      it 'returns idea if search price from is nil or zero' do
        Idea.between_price(nil, 200).should == [@idea]
      end
    end

    context "when idea has price from and price till" do
      before do
        @idea = create(:idea, price_from: 100, price_till: 200)
      end

      context 'when search has blank prices' do
        it 'returns idea' do
          Idea.between_price(nil, nil).should == [@idea]
          Idea.between_price(0, 0).should == [@idea]
        end
      end

      context 'when search has only price_from' do
        it 'skips idea if search price from is bigger than idea price till' do
          Idea.between_price(201, nil).should be_empty
        end
        it 'returns idea if search price from is less or equal than idea price till' do
          Idea.between_price(200, nil).should == [@idea]
        end
      end

      context 'when search has only price_till' do
        it 'returns idea if search price till is bigger or equal than idea price from' do
          Idea.between_price(nil, 100).should == [@idea]
        end

        it 'skips idea if search price till is less thank idea price from' do
          Idea.between_price(nil, 99).should be_empty
        end
      end

      context 'when search has price_from and price_till' do
        it 'skips idea if search prices are less then idea price from' do
          Idea.between_price(50, 99).should be_empty
        end

        it 'skips idea if search prices are bigger then idea price till' do
          Idea.between_price(201, 299).should be_empty
        end
        it 'returns idea if search price_from is between idea prices' do
          Idea.between_price(100, 200).should == [@idea]
          Idea.between_price(200, 299).should == [@idea]
        end
        it 'returns idea if search price_till is between idea prices' do
          Idea.between_price(5, 100).should == [@idea]
          Idea.between_price(150, 200).should == [@idea]
        end
        it 'returns idea if search price_from is less than idea price from and search price_till is bigger than idea price_till' do
          Idea.between_price(50, 300).should == [@idea]
        end 
      end
    end
  end
end
