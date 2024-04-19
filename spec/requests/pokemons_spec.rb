require 'rails_helper'

RSpec.describe "Pokemons", type: :request do
  describe "GET /index" do
    subject { get url }

    let(:url) { "/pokemons" }
    let(:result) { ::ApiConsumer.new("/pokemon/").call["results"] }

    it "returns 200" do
      subject
      expect(response.status).to eq(200)
    end

    it "has accurate body" do
      subject
      result.each do |result|
        expect(response.body).to include("name: #{result["name"]}")
      end
    end
  end
end
