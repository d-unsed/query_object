require 'spec_helper'

describe QueryObject::QueryObject do
  let(:query)            { double() }

  subject(:query_object) { described_class.new(query) }

  describe '#initialize' do
    its(:query) { is_expected.to eq(query) }
  end
end
