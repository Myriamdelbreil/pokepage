# frozen_string_literal: true

class PokemonsController < ApplicationController
  def index
    @offset = params[:offset].nil? ? '0' : params[:offset]
    response = ::ApiConsumer.new("/pokemon?offset=#{@offset}&limit=20").call
    results = response['results']

    @pokemons = results.pluck('name').map do |name|
      ::Pokemon.new(name)
    end
    @next_page = response['next']
    @previous_page = response['previous']
  end

  def show
    @pokemon = ::Pokemon.new(params[:name])
  end
end
