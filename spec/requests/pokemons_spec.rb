require 'rails_helper'

RSpec.describe 'Pokemons', type: :request do
  describe 'GET /index' do
    subject { get url }

    let(:url) { '/pokemons' }
    let(:result) { ::ApiConsumer.new('/pokemon/').call['results'] }

    it 'returns 200' do
      subject
      expect(response.status).to eq(200)
    end

    it 'has accurate body' do
      subject
      result.each do |result|
        expect(response.body).to include("name: #{result['name']}")
      end
    end
  end

  describe 'GET /show' do
    subject { get url, params: params }
    let(:params) { { name: 'bulbasaur' } }
    let(:url) { '/pokemons/1' }
    let(:pokemon) { Pokemon.new(params[:name]) }

    it 'returns 200' do
      subject
      expect(response.status).to eq(200)
    end

    it 'returns info about the pokemon' do
      subject
      expect(response.body).to include(params[:name])
      expect(response.body).to include("height: #{pokemon.height}")
      pokemon.types.map { |type| type.name }.each do |name|
        expect(response.body).to include(name)
      end
    end
  end
end
