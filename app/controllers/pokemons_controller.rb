# frozen_string_literal: true

class PokemonsController < ApplicationController
  def index
    @offset = params[:offset].nil? ? '0' : params[:offset]
    response = ::PokeApiConsumer.new("/pokemon?offset=#{@offset}&limit=20").call
    results = response['results']

    @pokemons = results.pluck('name').map do |name|
      ::Pokemon.new(name)
    end
    @next_page = response['next']
    @previous_page = response['previous']
  end

  def show
    name = params[:pokemon].present? ? params[:pokemon][:name] : params[:name]
    @pokemon = ::Pokemon.new(name)
  end
end
