# frozen_string_literal: true

class PokemonsController < ApplicationController
  def index
    results = ::ApiConsumer.new("/pokemon").call["results"]

    @pokemons = results.pluck("name").map do |name|
      ::Pokemon.new(name)
    end
  end

  def show
    @pokemon = ::Pokemon.new(params[:name])
  end
end
