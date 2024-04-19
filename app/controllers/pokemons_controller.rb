class PokemonsController < ApplicationController

  def index
    results = ::ApiConsumer.new("/pokemon").call["results"]

    @pokemons = results.pluck("name").map do |name|
      ::Pokemon.new(name)
    end
  end
end
