require 'spec_helper'

describe QueryObject::QueryObject do
  let(:query)            { spy('query') }
  subject(:query_object) { described_class.new(query) }

  describe '#initialize' do
    context 'when query is a relation' do
      its(:query) { is_expected.to be_instance_of(Proc) }
    end

    context 'when query is a block' do
      subject do
        described_class.new { query }
      end

      it 'does not wrap the block to a proc again' do
        expect(subject.query.call).to eq(query)
      end
    end
  end

  describe '#relation' do
    its(:relation) { is_expected.to eq(query) }
  end

  describe '#merge_with' do
    let(:another_query)        { double('another_query') }
    let(:another_query_object) { double('another_object', query: another_query) }
    subject!                   { query_object.merge_with(another_query_object) }

    it { is_expected.to be_instance_of(described_class) }

    it 'merges both ActiveRecord relations' do
      expect(query).to have_received(:merge).with(another_query)
    end
  end
end
