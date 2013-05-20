require 'spec_helper'

describe Item do
  describe "range_between" do
    context "when item has no values" do
      before do
        @item = create(:item, from: nil, till: nil)
      end
      it "should return item no mather what values are given in search" do
        Item.range_between(from: nil, till: nil).should  == [@item]
        Item.range_between(from: 0, till: nil).should    == [@item]
        Item.range_between(from: 100, till: nil).should  == [@item]
        Item.range_between(from: nil, till: 0).should    == [@item]
        Item.range_between(from: nil, till: 9000).should == [@item]
        Item.range_between(from: 100, till: 9000).should == [@item]
      end
    end

    context "when item has only from" do
      before do
        @item = create(:item, from: 100, till: nil)
      end

      it "skips item if till in search is less than item from" do
        Item.range_between(from: nil, till: 99).should  be_empty
        Item.range_between(from: 0, till: 99).should  be_empty
      end

      it 'returns item if search values are empty' do
        Item.range_between(from: nil, till: nil).should  == [@item]
      end

      it 'returns item if search till is nil or zero' do
        Item.range_between(from: 50, till: nil).should    == [@item]
        Item.range_between(from: 50, till: 0).should    == [@item]
      end

      it 'returs item if search till is bigger than items from' do
        Item.range_between(from: nil, till: 9000).should == [@item]
        Item.range_between(from: 50, till: 9000).should == [@item]
      end
    end

    context "when item has only till" do
      before do
        @item = create(:item, from: nil, till: 100)
      end

      it 'skips item if search from is bigger than item till' do
        Item.range_between(from: 101, till: nil).should be_empty
        Item.range_between(from: 101, till: 200).should be_empty
      end
      it 'returns item if search values are not given or equal to zero' do
        Item.range_between(from: nil, till: nil).should == [@item]
        Item.range_between(from: 0, till: 0).should == [@item]
      end

      it 'returns item if search from is less or equal to item till' do
        Item.range_between(from: 100, till: nil).should == [@item]
        Item.range_between(from: 50, till: 200).should == [@item]
      end

      it 'returns item if search from is nil or zero' do
        Item.range_between(from: nil, till: 200).should == [@item]
      end
    end

    context "when item has from and till" do
      before do
        @item = create(:item, from: 100, till: 200)
      end

      context 'when search has blank values' do
        it 'returns item' do
          Item.range_between(from: nil, till: nil).should == [@item]
          Item.range_between(from: 0, till: 0).should == [@item]
        end
      end

      context 'when search has only from' do
        it 'skips item if search from is bigger than item till' do
          Item.range_between(from: 201, till: nil).should be_empty
        end
        it 'returns item if search from is less or equal than item till' do
          Item.range_between(from: 200, till: nil).should == [@item]
        end
      end

      context 'when search has only till' do
        it 'returns item if search till is bigger or equal than item from' do
          Item.range_between(from: nil, till: 100).should == [@item]
        end

        it 'skips item if search till is less thank item from' do
          Item.range_between(from: nil, till: 99).should be_empty
        end
      end

      context 'when search has from and till' do
        it 'skips item if search range values are less then item from' do
          Item.range_between(from: 50, till: 99).should be_empty
        end

        it 'skips item if search range values are bigger then item till' do
          Item.range_between(from: 201, till: 299).should be_empty
        end
        it 'returns item if search from is between item values' do
          Item.range_between(from: 100, till: 200).should == [@item]
          Item.range_between(from: 200, till: 299).should == [@item]
        end
        it 'returns item if search till is between item values' do
          Item.range_between(from: 5, till: 100).should == [@item]
          Item.range_between(from: 150, till: 200).should == [@item]
        end
        it 'returns item if search from is less than item from and search till is bigger than item till' do
          Item.range_between(from: 50, till: 300).should == [@item]
        end 
      end
    end
  end
end
