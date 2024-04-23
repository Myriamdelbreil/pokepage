require 'rails_helper'

RSpec.describe 'Pokemons', type: :request do
  describe 'GET /index' do
    subject { get url }

    let(:url) { '/pokemons' }
    let(:result) { ::PokeApiConsumer.new('/pokemon/').call['results'] }

    it 'returns 200' do
      subject
      expect(response.status).to eq(200)
    end

    it 'has accurate body' do
      subject
      result.each do |result|
        expect(response.body).to include("<h2>#{result['name'].capitalize}</h2>")
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
    subject { get url }
    let(:url) { "/pokemons/#{params[:name]}" }
    let(:pokemon) { Pokemon.new(params[:name]) }
    let(:params) { { name: 'ghjk' } }

    it 'has option to go back to list' do
      subject
      expect(response.body).to include('<a href="/pokemons">Go back to list</a>')
    end

    context 'when pokemon not found' do
      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
      end

      it "returns 'Pokemon not found' message" do
        puts params[:name]
        puts "hello #{pokemon.name}"
        subject
        expect(response.body).to include("No pokemon found with name #{params[:name]}!")
      end
    end

    context 'when pokemon found' do
      let(:params) { { name: 'bulbasaur' } }

      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'returns info about the pokemon' do
        subject
        expect(response.body).to include(params[:name].capitalize)
        expect(response.body).to include("height: #{pokemon.height}")
        pokemon.types.map { |type| type.name }.each do |name|
          expect(response.body).to include(name)
        end
      end
    end
  end
end
