require 'spec_helper'
require 'ffaker'

describe 'neo4j products' do
  let(:klass) { Recs::Product }
  subject { klass.new(slug: Faker::Lorem.words.join(' ').parameterize) }

  describe :in_spree do
    after { subject.in_spree }

    it "look up the spree object with the same slug" do
      expect(Spree::Product).to receive(:find_by!).with(slug: subject.slug)
    end
  end
end
