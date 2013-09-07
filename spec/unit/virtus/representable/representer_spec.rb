# encoding: utf-8

require 'spec_helper'
require 'representable/hash'

describe Virtus::Representable, '#to_hash' do
  class B
    include Virtus

    attribute :b, String
  end

  class A
    include Virtus

    attribute :a, String
    attribute :b, B
  end

  module Representers
    module B
      include Virtus::Representable
      include Representable::Hash

      represent ::B
    end

    module A
      include Virtus::Representable
      include Representable::Hash

      represent ::A
    end
  end

  module OnlyRepresenters
    module B
      include Virtus::Representable
      include Representable::Hash

      represent ::B
    end

    module A
      include Virtus::Representable
      include Representable::Hash

      represent ::A, only: [:b]
    end
  end

  subject { value.extend(representer).to_hash }

  let(:value) { A.new(hash) }
  let(:hash)  { { 'a' => 'string', 'b' => { 'b' => 'string' } } }
  let(:representer) { Representers::A }

  it { should be_kind_of(Hash) }
  it { expect(hash).to eq(hash) }

  describe 'with ignored attributes' do
    let(:representer) { OnlyRepresenters::A }
    let(:expected_hash) { { 'b' => { 'b' => 'string' } } }

    it { expect(hash).to eq(hash) }
  end
end