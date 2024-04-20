# frozen_string_literal: true

class PokeApiConsumer
  include HTTParty

  URL = 'https://pokeapi.co/api/v2'

  def initialize(url_path)
    @url = URL + url_path
  end

  def call
    ::ApiConsumer::Client.new(@url).fetch_data
  end
end
