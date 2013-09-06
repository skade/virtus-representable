require 'spec_helper'
require 'representable/hash'

describe Virtus::Representable::Decorator, "#to_hash" do
  class B
    include Virtus

    attribute :b, String
  end

  class A
    include Virtus

    attribute :a, String
    attribute :b, B
  end

  module Decorators
    class B < Representable::Decorator
      include Virtus::Representable::Decorator
      include Representable::Hash

      represent ::B
    end

    class A < Representable::Decorator
      include Virtus::Representable::Decorator
      include Representable::Hash

      represent ::A
    end
  end

  module OnlyDecorators
    class B < Representable::Decorator
      include Virtus::Representable::Decorator
      include Representable::Hash

      represent ::B
    end

    class A < Representable::Decorator
      include Virtus::Representable::Decorator
      include Representable::Hash

      represent ::A, :only => [:b]
    end
  end

  subject {
    decorators.new(value).to_hash
  }
  let(:value) { A.new(hash) }
  let(:hash)  { { 'a' => "string", 'b' => { 'b' => "string" } } }
  let(:decorators) { Decorators::A }

  it { should be_kind_of(Hash) }
  it { expect(hash).to eq(hash) }

  describe "with ignored attributes" do
    let(:decorators) { OnlyDecorators::A }
    let(:expected_hash) { { 'b' => { 'b' => 'string'} } }

    it { expect(hash).to eq(hash) }
  end
end