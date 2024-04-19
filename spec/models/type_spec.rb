require 'rails_helper'

RSpec.describe Type, type: :model do
  subject { ::Type.new(name) }

  let(:result) { ::ApiConsumer.new("/type/#{name}").call }

  context "when type exists" do
    let(:name) { "ground" }

    it "returns type with accurate attributes" do
      damage_to = {
        "double_damage_to" => result["damage_relations"]["double_damage_to"].pluck("name"),
        "half_damage_to" => result["damage_relations"]["half_damage_to"].pluck("name"),
        "no_damage_to" => result["damage_relations"]["no_damage_to"].pluck("name")
      }
      expect(subject.name).to eq(result["name"])
      expect(subject.moves).to eq(result["moves"].pluck("name"))
      expect(subject.damage_to).to eq(damage_to)
    end
  end

  context "when type doesn't exist" do
  end
end
