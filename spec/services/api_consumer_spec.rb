# frozen_string_literal: true

require "rails_helper"

::RSpec.describe ::ApiConsumer, type: :service do
  subject do
    described_class.new(url).call
  end

  let(:url) { "/pokemon/90"}

  context "when unvalid url" do
    context "when resource doesn't exist" do
      let(:url) { "/pokemon/#{::SecureRandom.hex(10)}" }

      it "returns a 404" do
        expect(subject.response.code).to eq("404")
      end
    end
  end

  context "when valid url" do
    it "returns a 200" do
      expect(subject.response.code).to eq("200")
    end

    it "returns a json with expected attributes" do
      expect(subject.keys).to include("id", "abilities", "types", "past_types", "weight")
    end
  end
end
