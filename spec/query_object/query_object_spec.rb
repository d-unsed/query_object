require 'spec_helper'

describe QueryObject::QueryObject do
  let(:query)            { double() }

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
end
