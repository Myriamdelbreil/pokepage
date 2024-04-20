require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  subject { ::Pokemon.new(name) }

  let(:result) { ::PokeApiConsumer.new("/pokemon/#{name}").call }

  context "when pokemon exists" do
    let(:name) { "pikachu" }

    it "returns a pokemon with valid attributes" do
      expect(subject.is_default).to eq(result["is_default"])
      expect(subject.height).to eq(result["height"])
      expect(subject.weight).to eq(result["weight"])
      expect(subject.name).to eq(result["name"])
      expect(subject.moves).to match_array(result["moves"].map { |move| move["move"]["name"] })
      expect(subject.types.map { |type| type.name }).to match_array(result["types"].map { |type| type["type"]["name"] })
    end
  end

  context "when pokemon doesn't exist" do
    let(:name) { "toto" }

    it "returns a pokemon with empty attributes" do
      expect(subject.is_default).to be_nil
      expect(subject.height).to be_nil
      expect(subject.weight).to be_nil
      expect(subject.name).to be_nil
      expect(subject.moves).to be_empty
      expect(subject.types).to be_empty
    end
  end
end
