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

    context 'when pagination' do
      context 'when passing no offset params' do
        it 'has expected next page link' do
          subject
          expect(response.body).not_to include('Previous page')
          expect(response.body).to include('Next page')
        end
      end

      context 'when passing offset params' do
        context 'when there is still result to display in next page' do
          let(:url) { '/pokemons?offset=100' }

          it 'has pagination' do
            subject
            expect(response.body).to include('Next page')
            expect(response.body).to include('Previous page')
          end
        end

        context 'when there is no more result to display in next page' do
          let(:url) { '/pokemons?offset=1000000' }
          it 'has pagination' do
            subject
            expect(response.body).to include('Previous page')
            expect(response.body).not_to include('Next page')
          end
        end
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

    it 'has option to go back to list' do
      subject
      expect(response.body).to include('<a href="/pokemons">Go back to list</a>')
    end
  end
end
